#!/bin/bash
set -e

# Task 3: Modify a running website

cd "$(dirname "$0")/.."

export DOCKERID=neuralman159

# Remove old application containers
docker rm -f linux_tweet_app old_linux_tweet_app 2>/dev/null || true

# Restore original HTML
cp index-original.html index.html

# 1. Start website with bind mount
docker container run \
    --detach \
    --publish 80:80 \
    --name linux_tweet_app \
    --mount "type=bind,source=$(pwd),target=/usr/share/nginx/html" \
    "$DOCKERID/linux_tweet_app:1.0"

echo "Original website: http://localhost:80"
read -r -p "Press Enter to modify the website..."

# 2. Modify running website
cp index-new.html index.html

echo "Refresh http://localhost:80"
read -r -p "Press Enter to continue..."

# 3. Check original image
docker rm --force linux_tweet_app

docker container run \
    --detach \
    --publish 80:80 \
    --name linux_tweet_app \
    "$DOCKERID/linux_tweet_app:1.0"

echo "Check the original version at http://localhost:80"
read -r -p "Press Enter to continue..."

docker rm --force linux_tweet_app

# 4. Build image version 2.0
docker image build \
    --tag "$DOCKERID/linux_tweet_app:2.0" .

docker image ls

# 5. Run both versions
docker container run \
    --detach \
    --publish 80:80 \
    --name linux_tweet_app \
    "$DOCKERID/linux_tweet_app:2.0"

docker container run \
    --detach \
    --publish 8080:80 \
    --name old_linux_tweet_app \
    "$DOCKERID/linux_tweet_app:1.0"

docker container ls

echo "Version 2.0: http://localhost:80"
echo "Version 1.0: http://localhost:8080"

# 6. List application images
docker image ls -f "reference=$DOCKERID/*"

# 7. Push images to Docker Hub
read -r -p "Push images to Docker Hub? (y/N): " answer

if [[ "$answer" == "y" ]]; then
    docker login
    docker image push "$DOCKERID/linux_tweet_app:1.0"
    docker image push "$DOCKERID/linux_tweet_app:2.0"
fi
