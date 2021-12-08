#!/bin/bash
set -e

# preempt the gocd agent start with enabling the user
# access to a mounted docker socket if it is set
# TODO, ensure the correct permissions to execute the following
# commands via the gosu tool
echo "Assigning GID $DOCKER_GID to the go user"
if [ "$DOCKER_GID" ]; then
    groupadd -g $DOCKER_GID hostdocker
    usermod -a -G hostdocker go
fi

echo "Executing /docker-entrypoint.sh as go"
gosu go ./docker-entrypoint.sh