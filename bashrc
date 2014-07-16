#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#List of alias
alias ls='ls --color=auto'
alias log_cron_full='journalctl /usr/bin/crond'
alias log_cron_tail='journalctl -xn /usr/bin/crond'
alias log_cron_today='journalctl -x since=00:00:00 /usr/bin/crond'

#PS1
PS1='[\u@\h \W]\$ '


# Exports
export EDITOR=vim

# Initial Banner
echo "#################################################################"
echo "# __        __     _                                            #"
echo "# \ \      / /___ | |  ___  ___   _ __ ___    ___               #"
echo "#  \ \ /\ / // _ \| | / __|/ _ \ | '_ ` _ \  / _ \              #"
echo "#   \ V  V /|  __/| || (__| (_) || | | | | ||  __/ _            #"
echo "#    \_/\_/  \___||_| \___|\___/ |_| |_| |_| \___|( )           #"
echo "#                                                 |/            #"
echo "#  __  __            ____  _                                    #"
echo "# |  \/  | _ __     / ___|(_)  ___ __   __ __ _  _ __    ___    #"
echo "# | |\/| || '__|   | |  _ | | / _ \\ \ / // _` || '_ \  / _ \   #"
echo "# | |  | || | _    | |_| || || (_) |\ V /| (_| || | | ||  __/ _ #"
echo "# |_|  |_||_|(_)    \____||_| \___/  \_/  \__,_||_| |_| \___|(_)#"
echo "#                                                               #"
echo "#################################################################"
echo ""
echo ""
echo ""
echo "List of alias:"
echo "* log_cron_full"
echo "* log_cron_tail"
echo "* log_cron_today" 
