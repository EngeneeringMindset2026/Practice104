#!/usr/bin/env bash
# Task 1: Alpine, Ubuntu, MySQL
set -euo pipefail

echo "=== Alpine ==="
docker container run alpine hostname
docker container ls --all

echo
echo "=== Ubuntu (интерактивно) ==="
echo "Внутри выполни: ls / ; ps aux ; cat /etc/issue ; exit"
docker container run --interactive --tty --rm ubuntu bash

echo
echo "=== MySQL ==="
docker rm --force mydb 2>/dev/null || true
docker container run \
  --detach \
  --name mydb \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  mysql:latest

sleep 15
docker container ls
docker container logs mydb
docker container top mydb

docker exec -it mydb \
  mysql --user=root --password=my-secret-pw --version

echo
echo "Интерактивная оболочка: docker exec -it mydb sh"
echo "Удалить: docker rm --force mydb"
