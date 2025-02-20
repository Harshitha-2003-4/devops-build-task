#!/bin/bash

# Variables
DOCKER_HUB_USERNAME="manjunathdc"
IMAGE_NAME="devops-app"
TAG="dev"
SERVER_IP="34.215.200.114"

# Jenkins provides the SSH key as an environment
SSH_KEY="$SSH_KEY"  # Path to the SSH key provided by Jenkins

# Log the SSH key path
echo "Using SSH key: $SSH_KEY"

# Add server to known hosts
echo "Adding server to known_hosts..."
mkdir -p ~/.ssh
ssh-keyscan -H $SERVER_IP >> ~/.ssh/known_hosts
chmod 644 ~/.ssh/known_hosts

# SSH into the server and deploy the application
echo "Deploying application to server..."
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no ubuntu@$SERVER_IP << EOF
    echo "Updating system packages..."
    sudo apt update -y
    sudo apt upgrade -y

    # Pull the latest Docker image (force pull)
    echo "Pulling the latest Docker image..."
    sudo docker pull $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG --no-cache

    # Stop and remove the existing container if it exists
    echo "Stopping and removing existing container..."
    if sudo docker ps -a --format '{{.Names}}' | grep -q '^devops-app$'; then
        sudo docker stop devops-app || true
        sudo docker rm devops-app || true
    else
        echo "No existing container named 'devops-app' found."
    fi

    # Run the new container
    echo "Starting new container..."
    sudo docker run -d -p 80:80 --name devops-app $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG

    echo "Deployment completed successfully."
EOF

# Check if the container is running
echo "Verifying container status..."
ssh -i "$SSH_KEY" ubuntu@$SERVER_IP "sudo docker ps -a | grep devops-app"