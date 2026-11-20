#!/bin/bash
set -e

# Task 1: Run some simple Docker containers

# Alpine Linux
docker container run alpine hostname
docker container ls --all

# Ubuntu Linux
docker container run --interactive --tty --rm ubuntu bash

# Inside Ubuntu:
# ls /
# ps aux
# cat /etc/issue
# exit

# MySQL (reuse existing container if present)
if ! docker container inspect mydb >/dev/null 2>&1; then
    docker container run \
        --detach \
        --name mydb \
        -e MYSQL_ROOT_PASSWORD=my-secret-pw \
        mysql:latest
else
    docker container start mydb >/dev/null
fi

docker container ls
docker container logs mydb
docker container top mydb

# Check MySQL version
docker exec -it mydb mysql --version

# Open MySQL shell
docker exec -it mydb sh

# Inside MySQL container:
# mysql --user=root --password="$MYSQL_ROOT_PASSWORD" --version
# exit
