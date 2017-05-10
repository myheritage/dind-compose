#!/bin/sh
set -e
update-ca-trust force-enable
update-ca-trust extract

if ! docker info >/dev/null 2>&1
then
  if [ "$LOG" == "file" ]
  then
  	nohup dockerd -H 0.0.0.0:2375 -H unix:///var/run/docker.sock --storage-driver=vfs $DOCKER_DAEMON_ARGS &>/var/log/docker.log &
  else
  	nohup dockerd -H 0.0.0.0:2375 -H unix:///var/run/docker.sock --storage-driver=vfs $DOCKER_DAEMON_ARGS &
  fi
  (( timeout = 60 + SECONDS ))
  until docker info >/dev/null 2>&1
  do
  	if (( SECONDS >= timeout )); then
  		echo 'Timed out trying to connect to internal docker host.' >&2
      exit 1
  		break
  	fi
  	sleep 1
  done
fi
echo $@
if [[ "$1" == "sh" ]]; then
  exec $@
else
  [[ $1 ]] && exec sh -c "$*"
fi
