# Отчет по лабораторной работе №4
## Docker for Beginners (Linux)

Выполнил(а): **Громова Эльвира**  
Группа: **РИЗМ-161207**


### Цель работы

- Познакомиться с Docker.
- Изучить базовые команды Linux.
- Научиться запускать контейнеры, собирать образ по Dockerfile, использовать bind mounts и публиковать образы в Docker Hub.


### Что выполняла

Работа по туториалу:  
https://training.play-with-docker.com/beginner-linux/

Облачный терминал Play with Docker недоступен, поэтому команды выполняла локально через Docker Desktop.

Проект для сборки — учебное приложение **linux_tweet_app**  
(https://github.com/dockersamples/linux_tweet_app): простой сайт на nginx.

1. Запускала готовые контейнеры: Alpine, Ubuntu, MySQL.
2. Собирала свой образ по Dockerfile и запускала сайт.
3. Проверяла bind mount (правки файлов сразу видны в контейнере).
4. Собрала версии `1.0` и `2.0`, запускала их рядом на портах 80 и 8080.
5. Опубликовала образы в Docker Hub:  
   https://hub.docker.com/r/gromikkkk/linux_tweet_app


### Как запустить

Нужны Docker Desktop и аккаунт Docker Hub.

```bash
export DOCKERID=gromikkkk

bash 01_run_containers.sh
bash 02_build_and_run.sh
bash 03_bind_mount_and_versions.sh
bash 04_push_dockerhub.sh
```


### Выводы

Познакомилась с базовыми командами Docker: запуск контейнеров, сборка образа, монтирование папки и публикация в Docker Hub.  
Поняла, что контейнер работает, пока жив его главный процесс, а Dockerfile позволяет повторяемо собрать и запустить приложение на любой машине с Docker.  
Bind mount удобен при разработке: можно менять файлы на хосте без постоянной пересборки образа.
