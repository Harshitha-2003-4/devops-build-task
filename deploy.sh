#!/bin/bash

# Variables
DOCKER_HUB_USERNAME="manjunathdc"
IMAGE_NAME="devops-app"
TAG="dev"
SERVER_IP="35.88.136.230"

# Jenkins provides the SSH key as an environment variable
SSH_KEY="$SSH_KEY"  # Path to the SSH key provided by Jenkins

# Log the SSH key path
echo "Using SSH key: $SSH_KEY"

# SSH into the server and deploy the application
echo "Deploying application to server..."
ssh -i "$SSH_KEY" ubuntu@$SERVER_IP << EOF
    echo "Updating system packages..."
    sudo apt update -y
    sudo apt upgrade -y

    # Pull the latest Docker image
    echo "Pulling the latest Docker image..."
    docker pull $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG

    # Stop and remove the existing container if it exists
    echo "Stopping and removing existing container..."
    docker stop $IMAGE_NAME || true
    docker rm $IMAGE_NAME || true

    # Run the new container
    echo "Starting new container..."
    docker run -d -p 80:80 --name $IMAGE_NAME $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG

    echo "Deployment completed successfully."
EOF

# Check if the container is running
echo "Verifying container status..."
ssh -i "$SSH_KEY" ubuntu@$SERVER_IP "docker ps -a | grep $IMAGE_NAME"