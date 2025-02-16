#!/bin/bash

# Variables
DOCKER_HUB_USERNAME="manjunathdc"
IMAGE_NAME="devops-app"
TAG="latest"

# Build the Docker image
echo "Building Docker image..."
docker build -t $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG .

# Tag the image for the dev repository
echo "Tagging image for dev repository..."
docker tag $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG $DOCKER_HUB_USERNAME/$IMAGE_NAME:dev

# Login to Docker Hub
echo "Logging in to Docker Hub..."
docker login -u $DOCKER_HUB_USERNAME

# Push the image to Docker Hub
echo "Pushing image to Docker Hub..."
docker push $DOCKER_HUB_USERNAME/$IMAGE_NAME:dev

echo "Build and push process completed successfully."