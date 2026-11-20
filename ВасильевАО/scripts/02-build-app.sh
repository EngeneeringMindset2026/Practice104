#!/bin/bash
set -e

# Task 2: Package and run a custom app using Docker

cd "$(dirname "$0")/.."

export DOCKERID=neuralman159

# Restore original website
cp index-original.html index.html

# Display Dockerfile
cat Dockerfile

# Build image version 1.0
docker image build --tag "$DOCKERID/linux_tweet_app:1.0" .

# Remove existing lab container if needed
docker container rm --force linux_tweet_app 2>/dev/null || true

# Run website
docker container run \
    --detach \
    --publish 80:80 \
    --name linux_tweet_app \
    "$DOCKERID/linux_tweet_app:1.0"

echo "Website: http://localhost:80"
read -r -p "Press Enter after checking the website..."

# Remove container
docker container rm --force linux_tweet_app
