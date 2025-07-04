#!/bin/bash

set -e  # Exit on error

DOCKER_HUB_USERNAME="harshithaa2003"  # ✅ Use lowercase (as used in docker login)
IMAGE_NAME="devops-app"
TAG="${1:-dev}"  # Use provided tag, or default to 'dev'

# Compose full Docker image tag
IMAGE_TAG="docker.io/${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "🐳 Building Docker image: $IMAGE_TAG"
docker build -t "$IMAGE_TAG" .

if [[ -z "$DOCKER_HUB_CREDENTIALS_USR" || -z "$DOCKER_HUB_CREDENTIALS_PSW" ]]; then
    echo "❌ Docker credentials missing!"
    exit 1
fi

echo "🔐 Logging into Docker Hub..."
echo "$DOCKER_HUB_CREDENTIALS_PSW" | docker login -u "$DOCKER_HUB_CREDENTIALS_USR" --password-stdin

echo "🚀 Pushing image to Docker Hub: $IMAGE_TAG"
docker push "$IMAGE_TAG"

echo "✅ Build and push done for tag: $TAG"
