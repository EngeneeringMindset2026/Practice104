#!/bin/bash
# Скрипт с основными командами, выполненными в ходе работы №104

# Task 1
docker container run alpine hostname
docker container run --interactive --tty --rm ubuntu bash
docker container run --detach --name mydb -e MYSQL_ROOT_PASSWORD=my-secret-pw mysql:latest

# Task 2
export DOCKERID=denbotanin
docker image build --tag $DOCKERID/linux_tweet_app:1.0 .
docker container run --detach --publish 80:80 --name linux_tweet_app $DOCKERID/linux_tweet_app:1.0

# Task 3
docker container run --detach --publish 80:80 --name linux_tweet_app --mount type=bind,source="$(pwd)",target=/usr/share/nginx/html $DOCKERID/linux_tweet_app:1.0
cp index-new.html index.html
docker container rm --force linux_tweet_app
docker image build --tag $DOCKERID/linux_tweet_app:2.0 .
docker container run --detach --publish 80:80 --name linux_tweet_app $DOCKERID/linux_tweet_app:2.0
docker container run --detach --publish 8080:80 --name old_linux_tweet_app $DOCKERID/linux_tweet_app:1.0

# Публикация
docker login
docker image push $DOCKERID/linux_tweet_app:1.0
docker image push $DOCKERID/linux_tweet_app:2.0
