#!/bin/bash

set -e  # Exit on error

DOCKER_HUB_USERNAME="Harshithaa2003"
IMAGE_NAME="devops-app"
TAG="${1:-dev}"  # Use provided tag, or default to 'dev'

echo "🐳 Building Docker image: $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG"
docker build -t $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG .

if [[ -z "$DOCKER_HUB_CREDENTIALS_USR" || -z "$DOCKER_HUB_CREDENTIALS_PSW" ]]; then
    echo "❌ Docker credentials missing!"
    exit 1
fi

echo "🔐 Logging into Docker Hub..."
echo "$DOCKER_HUB_CREDENTIALS_PSW" | docker login -u "$DOCKER_HUB_CREDENTIALS_USR" --password-stdin

echo "🚀 Pushing image to Docker Hub: $TAG"
docker push $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG

echo "✅ Build and push done for tag: $TAG"
