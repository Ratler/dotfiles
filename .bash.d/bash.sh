[[ $- != *i* ]] && return

#set -o noclobber
export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history"
export HISTSIZE=10000
export PROMPT_DIRTRIM=2
shopt -s histappend
shopt -s cmdhist
