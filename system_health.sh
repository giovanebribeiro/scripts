#!/bin/bash
##
# File: system_health.sh
# Author: Giovane Boaviagem Ribeiro (giovanebribeiro)
# 
# Show a system diagnostics and send results to e-mail (optional) and pushover (optional)
##
VERSION=0.0.0
AUTHOR=giovanebribeiro


TEMP_FILE=$HOME/syshealth.log

#################
### FUNCTIONS ###
#################

check_dependencies(){
  TEMP=`which mpstat`
  TEMP=$? # get status from last command
  if [ $TEMP != 0 ]; then
    echo "sysstat package not found! Please install it and try again"
    exit 1
  fi

  TEMP=`which lscpu`
  TEMP=$?
  if [ $TEMP != 0 ]; then
    echo "lscpu package not found! Please install it and try again"
    exit 1
  fi

  TEMP=`which bc`
  TEMP=$?
  if [ $TEMP != 0 ]; then
    echo "bc package not found! Please install it and try again"
    exit 1
  fi

  TEMP=`which mailx`
  TEMP=$?
  if [ $TEMP != 0 ]; then
    echo "heirloom-mailx and postfix packages not found! Please install it and try again"
    exit 1
  fi

}

#
# Print the header of file
#
header(){
  echo "############################" >> $1
  echo "### System Health Report ###" >> $1
  echo "############################" >> $1
  echo "" >> $1
  echo "" >> $1
}

#
# Print the general info
#
general_info(){
  echo "** General Info" >> $1
  echo "Hostname: `hostname`" >> $1
  echo "Kernel Version: `uname -r`" >> $1
  echo "Uptime: `uptime | sed 's/.*up \([^,]*\), .*/\1/'`" >> $1
  echo "Last Reboot Time: `who -b | awk '{print $3, $4}'`" >> $1
  echo "" >> $1
  echo "" >> $1 
}

#
# Print the cpu info
#
cpu_info(){
  echo "** CPU usage:" >> $1
  echo "Ncpu = CPU number" >> $1
  echo "%usr = percentage of CPU usage with user level processes (applications):" >> $1
  echo "%sys = percentage of CPU usage with kernel processes" >> $1
  echo "%iow = percentage of CPU idle time with I/O requests" >> $1
  echo "%idle = percentage of CPU idle time" >> $1
  echo "------------------------------------- " >> $1
  echo "Ncpu    %usr    %sys    %iow    %idle " >> $1
  echo "------------------------------------- " >> $1
  cpus=`lscpu | grep -e "^CPU(s):" | cut -f2 -d: | awk '{print $1}'`
  i=0
  # for each cpu...
  while [ $i -lt $cpus ]; do
    # The output of mpstat command is:
    #14:44:48     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
    #14:44:48     all    2.31    2.89    2.07    0.95    0.00    0.61    0.00    0.00   91.16
    #14:44:48       0    2.71    2.39    1.91    0.89    0.00    2.43    0.00    0.00   89.67
    #14:44:48       1    2.17    2.97    2.18    0.94    0.00    0.02    0.00    0.00   91.72
    #14:44:48       2    2.39    3.27    2.28    1.04    0.00    0.02    0.00    0.00   91.01
    #14:44:48       3    1.98    2.91    1.92    0.94    0.00    0.02    0.00    0.00   92.22
    #
    # And, we need the value of '%usr' column. So:
    echo "CPU$i    `mpstat -P ALL | awk -v var=$i '{if($2 == var) print($3, "  ", $5, "  ", $6, "  ", $11)}'`" >> $1
    let i=$i+1
  done

  echo "------------------------------------- " >> $1
  echo "" >> $1
  echo "Load average: `uptime | awk -F'load average: ' '{print $2}' | cut -f1 -d, | awk '{if($1 > 2) print ($1, " (Unhealthy)"); else if($1 > 1) print ($1, " (Caution)"); else print ($1, " (Normal)")}'`" >> $1
  echo "" >> $1
  echo "" >> $1
}

#
# Print the process info
#
process_info(){
  echo "** Process info" >> $1
  echo "" >> $1
  echo "Top memory using process/application" >> $1
  echo "-------------------------------------------" >> $1
  echo "PID   || %MEM || RSS || COMMAND " >> $1
  echo "-------------------------------------------" >> $1
  ps aux | awk '{print $2, "  ", $4, "  ", $6, "  ", $11}' | sort -k3rn | head -n 10 >> $1

  echo "" >> $1
  echo "Top CPU using process/application" >> $1
  top -b -n1 | head -17 | tail -11 >> $1
  echo "" >> $1
  echo "" >> $1
}

#
# Print the disk info
#
disk_info(){
  echo "** Disk info" >> $1
  echo "(Status)     `df -Pkh | grep "Filesystem"`"  >> $1 # table header
  echo "--------------------------------------------------------------" >> $1 
  df -Pkh | grep ^/ > /tmp/df.status
  while read DISK
  do
    STATUS=`echo $DISK | awk '$1~"^/" && $5 >= 95{ print "(Unhealthy)"; } $1~"^/" && $5 >= 90{ print "(Caution)  "; } $1~"^/" && $5 < 90{ print "(Normal)   "; }'`
    echo "$STATUS  $DISK" >> $1
  done < /tmp/df.status

  rm /tmp/df.status # cleaning the trash
  echo "" >> $1
  echo "" >> $1
}

#
# memory info
#
memory_info(){
  # memory
  TOTALMEM=`free -m | head -2 | tail -1 | awk '{print $2}'`
  TOTALBC=`echo "scale=2;if($TOTALMEM == 0) print 0;$TOTALMEM/1024"|bc -l`
  USEDMEM=`free -m | head -2 | tail -1 | awk '{print $3}'`
  USEDBC=`echo "scale=2;if($USEDMEM == 0) print 0;$USEDMEM/1024"|bc -l`
  FREEMEM=`free -m | head -2 | tail -1 | awk '{print $4}'`
  FREEBC=`echo "scale=2;if($FREEMEM == 0) print 0;$FREEMEM/1024"|bc -l`

  # swap
  TOTALSW=`free -m | tail -1 | awk '{print $2}'`
  TOTALSWBC=`echo "scale=2;if($TOTALSW == 0) print 0;$TOTALSW/1024"|bc -l`
  USEDSW=`free -m | tail -1 | awk '{print $3}'`
  USEDSWBC=`echo "scale=2;if($USEDSW == 0) print 0;$USEDSW/1024"|bc -l`
  FREESW=`free -m | tail -1 | awk '{print $4}'`
  FREESWBC=`echo "scale=2;if($FREESW == 0) print 0;$FREESW/1024"|bc -l`

  echo "** Memory Info" >> $1
  echo "" >> $1
  echo "Physical Mem" >> $1
  echo "----------------------------" >> $1
  echo "Total   Used  Free  %Free" >> $1
  echo "----------------------------" >> $1
  echo "${TOTALBC}GB  ${USEDBC}GB   ${FREEBC}GB   $(( $FREEMEM*100/$TOTALMEM ))%" >> $1
  echo "" >> $1
  echo "Swap mem" >> $1
  echo "----------------------------" >> $1
  echo "Total   Used  Free  %Free" >> $1
  echo "----------------------------" >> $1
  echo "${TOTALSW}MB  ${USEDSW}MB   ${FREESW}MB   $(( $FREESW*100/$TOTALSW ))%" >> $1
  echo "" >> $1
  echo "" >> $1

}

bitcoin_info(){
  BITCOIN_INFO=`bitcoin-cli getinfo`
  echo "** Bitcoin Info" >> $1
  echo "" >> $1
  echo "${BITCOIN_INFO}" >> $1
}

#
# Print the help of script
#
_help(){
  echo "Made by giovanebribeiro"
  echo "Usage: $0 [options]"
  echo
  echo "Available options:"
  echo "-h Print this help"
  echo "-v Print the version"
  echo "-m your.email@mail.com The e-mail to send the report"
  echo "-p Send the report to pushover (pushover.net) app"
  echo "-l Just save the file in $HOME folder and print the result on screen"
}

#
# Print the version
#
_version(){
  echo "$VERSION"
}

#
# Mount the file
#
mount_file(){
  NOW=`date +%y%m%d%H%M`
  FILE1=$HOME/cotoco_report_${NOW}.log

  check_dependencies $FILE1
  header $FILE1
  general_info $FILE1
  cpu_info $FILE1
  process_info $FILE1
  disk_info $FILE1
  memory_info $FILE1
  bitcoin_info $FILE1

  cat $FILE1
}

send_to_email(){
  echo "** send to e-mail"
  FILE2="/tmp/syshealth.mail"

  check_dependencies $FILE2
  header $FILE2
  general_info $FILE2
  cpu_info $FILE2
  process_info $FILE2
  disk_info $FILE2
  memory_info $FILE2
  bitcoin_info $FILE2

  # send the email
  cat $FILE2 | mailx -v -A gmx -s "Cotoco Status Report" $1

  #print the result
  cat $FILE2

  rm $FILE2
}

send_to_pushover(){
  echo "** send to pushover"
  FILE3="/tmp/syshealth.pushover"
  check_dependencies $FILE3
  general_info $FILE3
  cpu_info $FILE3
  disk_info $FILE3 
  memory_info $FILE3
  bitcoin_info $FILE3

  INPUT=`cat $FILE3`
  /usr/local/bin/pushover sd cotoco "Status Report" "$INPUT"

  cat $FILE3
  rm $FILE3
}

######################
### MAIN EXECUTION ###
######################

while getopts hvm:p OP; do
  case "${OP}" in
    h) recv_h=1 
      ;;
    v) recv_v=1
      ;;
    m) email_to_send=${OPTARG}
      ;; 
    p) recv_p=1
      ;;
    l) recv_l=1
      ;;
  esac
done

[[ ${recv_h} ]] && _help
[[ ${recv_v} ]] && _version
[[ ${email_to_send} ]] && send_to_email ${email_to_send}
[[ ${recv_p} ]] && send_to_pushover
[[ ${recv_l} ]] && mount_file

#TEST=/tmp/test.txt
#general_info $TEST

#cat $TEST

exit 0

