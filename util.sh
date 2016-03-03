#!/bin/bash

# for vim colorscheme
export TERM=xterm-256color

# functions for docker ##############################################
# get runnning container list
_get_running_containers() {
  echo `docker ps | awk -v OFS=" " 'NR>1 {print $NF}' `
}
# set runnning container completion
_set_running_container_completion() {
  COMPREPLY=($(compgen -W "$(_get_running_containers)" -- "${COMP_WORDS[COMP_CWORD]}"))
}

# confirm function
_check_exec() {
  read -r -p "Are you sure? [y/N] " response

  ret=1
  case $response in
    [yY]) ret=0;;
  esac

  return $ret;
}

# exec docker
exec_docker_bash () {
  docker exec -it $1 /bin/bash
}
complete -F _set_running_container_completion exec_docker_bash

# rm runnning docker
rm_container_f () {
  if _check_exec ; then
    docker rm $(docker stop $1)
  fi
}
complete -F _set_running_container_completion rm_container_f

# rm obsolete docker image
rmi_docker_none_image () {
  docker rmi $(docker images -f dangling=true -q)
}

show_docker_stats() {
  docker stats $(_get_running_containers)
}

rm_volume_docker() {
  docker volume rm $(docker volume ls -qf dangling=true)
}

