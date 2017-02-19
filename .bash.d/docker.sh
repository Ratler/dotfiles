dsh() {
  local DOCKER_CONTAINERS IFS CONTAINER_ID DOCKER_HEADER

  IFS=$'\n'

  DOCKER_HEADER=$(docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}' | head -1)
  declare -a DOCKER_CONTAINERS=($(docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}'| tail -n +2 | tac))

  if [ -z $1 ]; then
    echo "Choose docker container to start shell in:"
    echo -e "#\t$DOCKER_HEADER"
    for i in ${!DOCKER_CONTAINERS[@]}; do
      printf "%s\t%s\n" "$i" "${DOCKER_CONTAINERS[$i]}"
    done
    echo -n "Container #> "
    read ANS
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
    *)
    ;;
  esac
}
