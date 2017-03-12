ve() {
  local VENV VENV_DIR ANS NEWENV
  VENV_DIR=~/.virtualenvs

  declare -a VENV=($(find $VENV_DIR -maxdepth 1 -type d | tail -n +2))
  if [ -z $1 ]; then
    echo "Choose python virtualenv to activate:"
    for i in ${!VENV[@]}; do
      printf "%s)\t%s\n" "$i" "${VENV[$i]##*/}"
    done

    if [ -n "$VIRTUAL_ENV" ]; then
      printf "d)\tdeactivate (${VIRTUAL_ENV##*/})\n"
    fi

    if [[ ${#VENV[@]} > 0 ]]; then
      printf "r)\tremove virtualenv\n"
    fi

    printf "n)\tnew virtualenv\n"
    echo -n "Env #> "
    read ANS
  else
    ANS=$1
  fi

  case "$ANS" in
   +([0-9]))
      if [ -n "${VENV[$ANS]}" ]; then
        echo "Activating ${VENV[$ANS]##*/}"
        . ${VENV[$ANS]}/bin/activate
      fi
      ;;
    n|N)
      if [ -z $2 ]; then
        echo -n "Enter name for new virtualenv: "
        read NEWENV
      else
        NEWENV=$2
      fi
      if [ -z "$NEWENV" ]; then
        return
      fi

      PIP=pip3
      if [[ $NEWENV =~ -py2$ ]]; then
        VARGS="-p python2"
        PIP=pip2
      fi
      virtualenv ${VARGS:--p python3} $VENV_DIR/$NEWENV
      . $VENV_DIR/$NEWENV/bin/activate
      $PIP install nose nosexcover pylint pyflakes pep8 ipython
      ;;
    d|D)
      if [ -n "$VIRTUAL_ENV" ]; then
        deactivate
      fi
      ;;
    r|R)
      echo -n "Remove virtualenv #: "
      read ANS
      if [ -d "${VENV[$ANS]}" ];  then
        rm -rf "${VENV[$ANS]}"
      fi
      ;;
    *)
      ;;
  esac
}

__ve_prompt() {
  if [ -n "$VIRTUAL_ENV" ]; then
    printf "$1" "${VIRTUAL_ENV##*/}"
  fi
}

alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
