#
# ~/.bashrc
# Author: Giovane Boaviagem
# Running on Arch Linux
# Based on Novell script (https://www.novell.com/coolsolutions/tools/17142.html)
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# EXPORTS
###############################################
export PS1='\W \$ '
export EDITOR=/usr/bin/vim
PATH=$PATH:/home/giovane/workspace/scripts/ ;export PATH
export HISTFILESIZE=3000 # The bash history should save 3000 commands
export HISTCONTROL=ignoredups # don't put duplicate lines in the history
export PYTHON=python2.7 # para o npm
export PGROOT="/home/giovane/workspace/_servers/postgres"

# Some colors
BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m'              # No Color

# SOME SOURCES AND SCRIPTS
###############################################

# source global definitions
if [ -f /etc/bashrc ] ; then
	. /etc/bashrc
fi

# bash completition
if [ -f /etc/bash_completion ] ; then
	. /etc/bash_completion
fi


# ALIASES
################################################
alias ls='ls --color=auto'
alias ps="ps auxf"
alias log-cron-full="journalctl /usr/bin/crond"
alias log-cron-tail="journalctl -xn /usr/bin/crond"
alias log-cron-today="journalctl -x --since='00:00:00' /usr/bin/crond"
alias pi_backup="sh /home/giovane/workspace/scripts/raspberry b"
alias pi_services="sh /home/giovane/workspace/scripts/raspberry s"
alias cleaner="sh /home/giovane/workspace/scripts/cleaner --deep"
alias untar="tar -zxvf"
# chmod alias
alias cmx="chmod a+x"
alias c000="chmod 000"
alias c644="chmod 644"
alias c755="chmod 755"
# file edit alias
alias bashedit="/usr/bin/vim /home/giovane/workspace/scripts/bashrc"

# FUNCTIONS
###############################################
#spin(){
#echo -ne "${RED}-"
#echo -ne "${WHITE}\b|"
#echo -ne "${BLUE}\bx"
#sleep .02
#echo -ne "${RED}\b+${NC}"
#}

# WELCOME SCREEN
###############################################
clear
#for i in `seq 1 30` ; do spin ; done; echo -ne "${WHITE} Hello, ${USER}!! ${NC}"; for i in `seq 1 30` ; do spin ; done; echo "" 
#echo -ne "${WHITE}Today is: "; date
#echo -e "${CYAN}"; cal; 
echo -e "${WHITE}"; uname -smr
#echo -e "`bash --version`"
echo -ne "\n${WHITE}"; df -h | grep Filesystem ; 
echo -e "${CYAN}"; df -h | grep -v Filesystem | grep -v /dev/shm | grep -v devtmpfs | grep -v tmpfs;
echo -e "\n${WHITE}Uptime:$NC"; uptime
#for i in `seq 1 77` ; do spin ; done; echo ""; echo "";
