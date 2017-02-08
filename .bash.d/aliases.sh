__aliases() {
  local alias_file cmd alias_name alias_cmd aaliases count
  alias_file=~/.aliases

  cmd=$1
  alias_name=$2; shift 2
  alias_cmd=$*

  if [[ -z "$cmd" ]]; then
    echo "error"
    return
  fi

  check_alias() {
    if grep -q "^$1:" $alias_file; then
      return 0
    fi
    return 1
  }

  case "$cmd" in
    a)
      if ! check_alias $alias_name; then
        echo "$alias_name:$alias_cmd" >> $alias_file
        alias $alias_name="$alias_cmd"
      else
        echo "Alias already exists"
      fi
      ;;
    l)
      count=1
      while read line; do
        printf "alias %s=\"%s\"\n" "${line%%:*}" "${line##*:}"
      done < $alias_file
      ;;
    load)
      while read line; do
        eval $(printf "alias %s=\"%s\"\n" "${line%%:*}" "${line##*:}")
      done < $alias_file
      ;;
    d)
      sed -i "/^$alias_name:/d" $alias_file
      unalias $alias_name
      ;;
    u)
      sed -i "/^$alias_name:/s;:.*;:$alias_cmd;" $alias_file
      alias $alias_name="$alias_cmd"
      ;;
    *)
      ;;
  esac
}

alias ls='ls --color=auto'
alias a="__aliases"
alias rdesktop="rdesktop -g 1280x960 -k sv -K"
alias git="hub"
alias pysmtp="su -c 'python -m smtpd -n -c DebuggingServer localhost:25'"
alias open="xdg-open"
alias gk="killall -9 gpg-agent; gpg-agent --daemon; gpg --card-status"

__aliases load
