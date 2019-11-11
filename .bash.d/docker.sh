shopt -s extglob
dsh() {
  local DOCKER_CONTAINERS IFS CONTAINER_ID DOCKER_HEADER
  ORIG_IFS=$IFS
  NEW_IFS=$'\n'
  IFS=$NEW_IFS

  DOCKER_HEADER=$(docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}' | head -1)
  declare -a DOCKER_CONTAINERS=($(docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}'| tail -n +2 | tac))

  print_containers() {
    for i in ${!DOCKER_CONTAINERS[@]}; do
      printf "%s\t%s\n" "$i" "${DOCKER_CONTAINERS[$i]}"
    done
  }

  if [ -z $1 ]; then
    if complete -v fzf &> /dev/null; then
      ANS=$(print_containers | fzf --tac --prompt 'Start a shell in container: ')
      ANS=$(echo $ANS | awk '{ print $1 }')
    else
      echo "Start a shell in container:"
      echo -e "#\t$DOCKER_HEADER"
      print_containers
      echo -n "Container #> "
      read ANS
    fi
  else
    ANS=$1
  fi

  case "$ANS" in
    +([0-9]))
      if [ -n "${DOCKER_CONTAINERS[$ANS]}" ]; then
        CONTAINER_ID=$(echo ${DOCKER_CONTAINERS[$ANS]} | awk '{ print $1 }')
        echo "Starting a shell in $CONTAINER_ID"
        docker exec -ti $CONTAINER_ID bash
      fi
    ;;
    +([a-zA-Z]))
      if [[ $(docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}' | tail -n +2 | tac | grep -c $ANS) -eq 1  ]]; then
        docker exec -ti $(docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}' | grep $ANS | awk '{ print $1}') bash
      else
        echo "Search criteria matched more then one container."
      fi
    ;;
    *)
    ;;
  esac
  IFS=$ORIG_IFS
}

alias d="docker"
alias dco="docker-compose"

if [ -f "/usr/local/etc/bash_completion.d/docker-compose" ]; then
  complete -F _docker_compose dco
fi
