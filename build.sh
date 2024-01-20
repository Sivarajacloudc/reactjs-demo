#!/bin/bash
# Check if both username and password arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <docker-hub-username> <tag-name>"
    exit 1
fi

DOCKER_HUB_USERNAME="$1"
TAG="$2"


# Build Docker image
docker build -t ${DOCKER_HUB_USERNAME}/reactjs-demo:${TAG} .
