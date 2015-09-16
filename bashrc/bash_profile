[[ $- != *i* ]] && return


# EXPORTS
###############################################
export CLICOLOR='true'
export LSCOLORS="gxfxcxdxbxCgCdabagacad"
alias ps="ps aux"
alias ls='ls -G'
export EDITOR='/usr/bin/vim'

parse_git_branch(){
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1='\n\[$(tput setaf 4)\][\w] \n\[$(tput setaf 1)\]$(parse_git_branch)\[$(tput sgr0)\] \$ '

