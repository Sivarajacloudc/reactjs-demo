#!/bin/bash

# Check if both username and password arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <docker-hub-username> <docker-hub-password>"
    exit 1
fi

DOCKER_HUB_USERNAME="$1"
DOCKER_HUB_PASSWORD="$2"
TAG="$3"
# Docker login to your Docker Hub account
echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin

# Pull the Docker image
docker pull "${DOCKER_HUB_USERNAME}/reactjs-demo:${TAG}"

# Start Docker Compose or any other deployment steps
docker-compose up -d