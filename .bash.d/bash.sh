#[[ $- != *i* ]] && return

export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:jobs"
export HISTSIZE=-1
export PROMPT_DIRTRIM=2
#shopt -s histappend
shopt -s cmdhist


if type fzf &> /dev/null; then
  if [ -f /usr/shar/fzf/completion.bash ]; then
    . /usr/share/fzf/completion.bash
    . /usr/share/fzf/key-bindings.bash
  elif [ -f /usr/local/opt/fzf/shell/completion.bash ]; then
    . /usr/local/opt/fzf/shell/completion.bash
    . /usr/local/opt/fzf/shell/key-bindings.bash
  fi

  h() {
    ag --nobreak --nofilename "$*" $HOME/.bash_history $HOME/.bash_history.d
  }

  hi() {
    ag --nobreak --nofilename "$*" $HOME/.bash_history $HOME/.bash_history.d | fzf
  }

  complete -cf h
  complete -cf hi
fi
