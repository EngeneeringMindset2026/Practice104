#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "$0")"

case "${1:-}" in
  containers)
    docker container run alpine hostname
    docker container ls --all --filter ancestor=alpine

    printf '\nВ контейнере Ubuntu выполни ls /, ps aux, cat /etc/issue и exit.\n'
    docker container run -it --rm ubuntu bash

    db=$(docker container run --detach --rm \
      -e MYSQL_ROOT_PASSWORD=my-secret-pw mysql:latest)
    trap 'docker container stop "$db" >/dev/null' EXIT
    docker container ls --filter "id=$db"
    docker container logs --tail 20 "$db"
    docker container top "$db"
    docker container exec "$db" mysql --version
    ;;

  website)
    workdir=$(mktemp -d)
    app_v1=''
    app_v2=''

    cleanup() {
      if [[ -n "$app_v1" ]]; then
        docker container stop "$app_v1" >/dev/null
      fi
      if [[ -n "$app_v2" ]]; then
        docker container stop "$app_v2" >/dev/null
      fi
      rm -rf -- "$workdir"
    }

    trap cleanup EXIT
    mkdir "$workdir/site"
    chmod 755 "$workdir/site"
    cp Dockerfile index.html index-new.html linux.png "$workdir/site/"

    url_v1=http://127.0.0.1:18080/
    url_v2=http://127.0.0.1:18081/

    check_page() {
      curl --fail --silent --show-error --retry 10 --retry-all-errors --retry-delay 1 --max-time 5 \
        "$1" --output "$workdir/response.html"
      cmp "$2" "$workdir/response.html"
      sha256sum "$workdir/response.html"
    }

    docker image build -t practice104-linux-tweet-app:1.0 "$workdir/site"
    app_v1=$(docker container run --detach --rm \
      --publish 127.0.0.1:18080:80 \
      --mount "type=bind,source=$workdir/site,target=/usr/share/nginx/html,readonly" \
      practice104-linux-tweet-app:1.0)

    printf '\nВерсия 1.0 с bind mount до изменения файла\n'
    check_page "$url_v1" index.html
    cp "$workdir/site/index-new.html" "$workdir/site/index.html"
    printf '\nТот же контейнер после изменения файла\n'
    check_page "$url_v1" index-new.html

    docker container stop "$app_v1" >/dev/null
    app_v1=$(docker container run --detach --rm \
      --publish 127.0.0.1:18080:80 practice104-linux-tweet-app:1.0)

    docker image build -t practice104-linux-tweet-app:2.0 "$workdir/site"
    app_v2=$(docker container run --detach --rm \
      --publish 127.0.0.1:18081:80 practice104-linux-tweet-app:2.0)

    printf '\nВерсия 1.0 без bind mount\n'
    check_page "$url_v1" index.html
    printf '\nВерсия 2.0 без bind mount\n'
    check_page "$url_v2" index-new.html
    ;;

  *)
    printf 'Использование: %s {containers|website}\n' "$0" >&2
    exit 2
    ;;
esac
