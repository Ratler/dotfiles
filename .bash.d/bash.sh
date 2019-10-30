#[[ $- != *i* ]] && return

export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:jobs"
export HISTSIZE=15000
export PROMPT_DIRTRIM=2
shopt -s histappend
shopt -s cmdhist


if type fzf &> /dev/null; then
  if [ -f /usr/share/fzf/completion.bash ]; then
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

  s() {
    local dir
    dir=($(find -L $HOME/src \
                $HOME/src/lunar \
                -maxdepth 1 -type d -name "*$1*" -a ! -name ".Trashes" -a ! -name ".fseventsd" -a ! -name "lunar" -print 2> /dev/null))

    if [[ "$dir" == "" ]]; then
      echo "No match found for '$1'."
      return
    fi

    if [[ "${!dir[@]}" == 0 ]]; then
      cd "${dir[0]}"
    else
      dir=$(printf '%s\n' "${dir[@]}" | fzf +m)
      cd "$dir"
    fi
  }

  complete -cf h
  complete -cf hi
fi
