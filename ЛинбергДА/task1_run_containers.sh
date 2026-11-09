#!/usr/bin/env bash
# Task 1. Запуск простых контейнеров: Alpine, Ubuntu, MySQL.
set -euo pipefail
cd "$(dirname "$0")" && source ./env.sh
set -x

# 1.1. Одна команда в контейнере Alpine
docker container run alpine hostname
docker container ls --all

# 1.2. Ubuntu. В тренинге контейнер запускается интерактивно
#      (docker container run --interactive --tty --rm ubuntu bash),
#      здесь те же команды выполняются внутри контейнера без терминала.
docker container run --rm ubuntu bash -c 'ls /; ps aux; cat /etc/issue'
# Та же команда на хосте показывает ОС хоста, а не контейнера
cat /etc/issue 2>/dev/null || uname -a

# 1.3. MySQL в фоновом режиме
docker container run \
  --detach \
  --name mydb \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  mysql:latest
docker container ls
sleep 5
docker container logs mydb | tail -n 20
docker container top mydb
# Переменная MYSQL_ROOT_PASSWORD раскрывается внутри контейнера
docker exec mydb sh -c 'mysql --user=root --password=$MYSQL_ROOT_PASSWORD --version'
