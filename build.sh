#!/bin/bash
set -e

# Ensure lowercase
DOCKER_HUB_USERNAME=$(echo "harshithaa2003" | tr '[:upper:]' '[:lower:]')
IMAGE_NAME=$(echo "devops-app" | tr '[:upper:]' '[:lower:]')
TAG="${1:-dev}"  # Default tag is 'dev'

IMAGE_TAG="docker.io/${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${TAG}"

# Check Docker installed
if ! command -v docker &>/dev/null; then
    echo "❌ Docker is not installed or not in PATH"
    exit 1
fi

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

echo "✅ Build and push complete!"

