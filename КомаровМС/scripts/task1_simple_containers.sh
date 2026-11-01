#!/usr/bin/env bash
# Task 1: Run some simple Docker containers
#  - контейнер, выполняющий одну задачу (Alpine + hostname)
#  - интерактивный контейнер (Ubuntu + bash)
#  - фоновый контейнер (MySQL)

set -euo pipefail

run() { echo; echo "\$ $*"; "$@"; }

echo "=== 1.1 Одна задача в контейнере Alpine ==="
run docker container run alpine hostname
# Контейнер завершился, но не удалён - он в состоянии Exited
run docker container ls --all

echo
echo "=== 1.2 Интерактивный контейнер Ubuntu ==="
# В интерактивном режиме внутри контейнера выполняются: ls /, ps aux, cat /etc/issue, exit
#   docker container run --interactive --tty --rm ubuntu bash
# Для скрипта те же команды передаются в bash без TTY:
run docker container run --interactive --rm ubuntu bash -c 'ls /; echo; ps aux; echo; cat /etc/issue'
echo "Дистрибутив хоста:"
cat /etc/issue 2>/dev/null || cat /etc/os-release

echo
echo "=== 1.3 Фоновый контейнер MySQL ==="
run docker container run \
  --detach \
  --name mydb \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  mysql:latest

run docker container ls

echo "Ждём запуска MySQL..."
sleep 20

run docker container logs --tail 15 mydb
run docker container top mydb

# Переменная $MYSQL_ROOT_PASSWORD должна раскрываться ВНУТРИ контейнера,
# поэтому команда передаётся через sh -c в одинарных кавычках
run docker exec mydb sh -c 'mysql --user=root --password=$MYSQL_ROOT_PASSWORD --version'

# Интерактивная оболочка внутри работающего контейнера (выполняется вручную):
#   docker exec -it mydb sh
#   mysql --user=root --password=$MYSQL_ROOT_PASSWORD --version
#   exit
