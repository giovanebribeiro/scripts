#
# ~/.bashrc
# Author: Giovane Boaviagem
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# EXPORTS
# if exports file exists, load it!
[ -r "$HOME/.exports.sh" ] && source "$HOME/.exports.sh" &>/dev/null

# ALIASES
# if aliases file exists, load it!
[ -r "$HOME/.aliases.sh" ] && source "$HOME/.aliases.sh" &>/dev/null

# PS1
# auxiliary function (returns the current git branch name)
parse_git_branch(){
  git --version | grep "git" > /dev/null 2>&1 || return
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# if the system is linux, ps1 will be in linux format. Otherwise, in mac format.
if [ "$(uname -a | grep "Linux")" != "" ] ; then
  export PS1='\n\e[1;36m[\w]\e[1;33m(\h)\e[0m\n\u \e[0;31m$(parse_git_branch) \e[1;37m->\e[0m ' 
else
  export PS1='\n\[$(tput setaf 6)\][\w]$(tput bold)$(tput setaf 3)(\h) \n\[$(tput sgr0)\]\u\[$(tput setaf 1)\]$(parse_git_branch)\[$(tput sgr0)\] \[$(tput bold)\]\[$(tput setaf 7)\]-> \[$(tput sgr0)\]'
fi
