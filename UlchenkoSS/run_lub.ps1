# run-lab.ps1
# Скрипт для выполнения лабораторной работы по Docker (Windows PowerShell)

# 1. Установка переменной с твоим логином Docker Hub
# ВАЖНО: Замени "Your_dockerid" на свой реальный никнейм на Docker Hub!
$env:DOCKERID = "Your_dockerid"
# Клонирование репозитория для работы, пропусти этот шаг если репозиторий уже установлен в папку работы
git clone https://github.com/dockersamples/linux_tweet_app
# 2. Запустите несколько простых контейнеров Docker
# Контейнер запустится, выполнит команду hostname, а затем завершит работу.
docker container run alpine hostname
# Команда откроет интерактивную сессию. Выйти из неё можно командой exit.
docker container run --interactive --tty --rm ubuntu bash
# Запуск базы данных MySQL в фоне
docker container run --detach --name mydb -e MYSQL_ROOT_PASSWORD=my-secret-pw mysql:latest
# Команда `docker container exec` позволяет выполнять команды внутри контейнера.
# В этом примере мы воспользуемся `docker container exec`, чтобы запустить внутри контейнера MySQL команду, эквивалентную `mysql --user=root --password=$MYSQL_ROOT_PASSWORD --version`.
docker exec -it mydb mysql --user=root --password=$MYSQL_ROOT_PASSWORD --version
# 3. Упаковка и запуск пользовательского приложения с помощью Docker
cd linux_tweet_app
# Сборка собственного образа веб-приложения
docker image build --tag $env:DOCKERID/linux_tweet_app:1.0 .
# Запуск собственного контейнера, можно посмотреть по ссылке http://localhost/
docker container run --detach --publish 80:80 --name linux_tweet_app $env:DOCKERID/linux_tweet_app:1.0
# Остановка собственного контейнера
docker container rm --force linux_tweet_app
# Запуск собственного контейнерас монтированием, можно посмотреть по ссылке http://localhost/
docker container run --detach --publish 80:80 --name linux_tweet_app --mount type=bind,source="$(pwd)",target=/usr/share/nginx/html $env:DOCKERID/linux_tweet_app:1.0
# Изменение сайта во время его работы
cp index-new.html index.html
docker rm --force linux_tweet_app
# Сборка второго веб приложения
docker image build --tag $env:DOCKERID/linux_tweet_app:2.0 .
# Запуск второго контейнера, можно посмотреть по ссылке http://localhost/
docker container run --detach --publish 80:80 --name linux_tweet_app $env:DOCKERID/linux_tweet_app:2.0
# Запуск первого контейнера на другом порте, можно посмотреть по ссылке http://localhost:8080/
docker container run --detach --publish 8080:80 --name old_linux_tweet_app $env:DOCKERID/linux_tweet_app:1.0
# 4. Публикация образа
# Вход в твой аккаунт DockerHub
docker login
# Публикация образов в твоём DockerHub
docker image push $env:DOCKERID/linux_tweet_app:1.0
docker image push $env:DOCKERID/linux_tweet_app:2.0