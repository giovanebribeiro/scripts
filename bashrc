#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#List of alias
alias ls='ls --color=auto'
alias log-cron-full="journalctl /usr/bin/crond"
alias log-cron-tail="journalctl -xn /usr/bin/crond"
alias log-cron-today="journalctl -x --since='00:00:00' /usr/bin/crond"

#PS1
PS1='[\u@\h \W]\$ '


# Exports
export EDITOR=vim

# Initial Banner
echo 
cat << "EOT"

#################################################################
# __        __     _                                            #
# \ \      / /___ | |  ___  ___   _ __ ___    ___               #
#  \ \ /\ / // _ \| | / __|/ _ \ | '_ ` _ \  / _ \              #
#   \ V  V /|  __/| || (__| (_) || | | | | ||  __/ _            #
#    \_/\_/  \___||_| \___|\___/ |_| |_| |_| \___|( )           #
#                                                 |/            #
#  __  __            ____  _                                    #
# |  \/  | _ __     / ___|(_)  ___ __   __ __ _  _ __    ___    #
# | |\/| || '__|   | |  _ | | / _ \\ \ / // _` || '_ \  / _ \   #
# | |  | || | _    | |_| || || (_) |\ V /| (_| || | | ||  __/ _ #
# |_|  |_||_|(_)    \____||_| \___/  \_/  \__,_||_| |_| \___|(_)#
#                                                               #
#################################################################
EOT
echo 
echo 
echo
echo "List of alias:"
echo "* log-cron-full"
echo "* log-cron-tail"
echo "* log-cron-today"
echo 
echo 
echo  
