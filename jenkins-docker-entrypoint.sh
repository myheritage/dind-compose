#!/bin/sh
set -e
update-ca-trust force-enable
update-ca-trust extract

if [ "$LOG" == "file" ]
then
	dockerd -H 0.0.0.0:2375 -H unix:///var/run/docker.sock --storage-driver=vfs $DOCKER_DAEMON_ARGS &>/var/log/docker.log &
else
	dockerd -H 0.0.0.0:2375 -H unix:///var/run/docker.sock --storage-driver=vfs $DOCKER_DAEMON_ARGS &
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
[[ $1 ]] && exec "$@"
exec bash --login
