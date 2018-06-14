__kerberos_ticket() {
  local KLIST_OUTPUT expired _MSG found

  if [[ -e /tmp/krb5cc_$UID ]] || [[ -n $KRB5CCNAME ]]; then
    if [ -x $KLIST ]; then
      KLIST_OUTPUT="$($KLIST 2> /dev/null | grep -v 'No ticket')"
      for i in $KLIST_OUTPUT; do
        if [[ -n $found ]]; then
          _MSG=$(echo $i | cut -d@ -f1)
          break
        fi
        if [ $i == "Principal:" ]; then
          found=1
        fi
      done

      if echo $KLIST_OUTPUT | grep -q ">>>Expired<<<"; then
        expired=1
      fi
      if [[ -n $_MSG ]]; then
        if [[ -n $expired ]]; then
          printf "$1" "$_MSG"
        else
          printf "$2" "$_MSG"
        fi
      fi
    fi
  fi
}

C1="\[\033[0;36m\]"     # cyan
C2="\[\033[1;36m\]"     # light cyan
C3="\[\033[1;30m\]"     # light grey
C4="\[\033[1;37m\]"     # white
C5="\[\033[1;31m\]"     # red
RESET="\[\e[0m\]"
PS1="${titlebar}$C1: \$(__ve_prompt '[$C4%s$C1] ')\$(__kerberos_ticket '($C5%s$C1) ' '($C2%s$C1) ')\u$C2@$C1\h \w\$(__git_ps1 ' ($C2%s$C1)') ;$RESET "
PS2="$C1>$C4\[\033[0m\] "

export VIRTUAL_ENV_DISABLE_PROMPT=1
export PS1 PS2

# If powerline exists load it
if [ -f "/usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh" ]; then
  . /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
elif [ -f "/usr/local/lib/python3.6/site-packages/powerline_status-2.6-py3.6.egg/powerline/bindings/bash/powerline.sh" ]; then
  . /usr/local/lib/python3.6/site-packages/powerline_status-2.6-py3.6.egg/powerline/bindings/bash/powerline.sh
elif [ -f "/usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh" ]; then
  . /usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
elif [ -f "/usr/share/bash/powerline.sh" ]; then
  . /usr/share/bash/powerline.sh
fi
