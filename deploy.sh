#!/bin/bash

set -e

# --- Config ---
DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME:-Harshithaa2003}"
DOCKER_HUB_PASSWORD="${DOCKER_HUB_PASSWORD:-}"  # Passed from Jenkins
IMAGE_NAME="devops-app"
TAG="${1:-dev}"
SERVER_IP="35.91.242.160"
SSH_KEY="$SSH_KEY"

# --- Check for key ---
if [[ ! -f "$SSH_KEY" ]]; then
    echo "❌ SSH key not found: $SSH_KEY"
    exit 1
fi

# --- Prepare SSH ---
echo "✅ Adding server to known_hosts..."
mkdir -p ~/.ssh
ssh-keyscan -H $SERVER_IP >> ~/.ssh/known_hosts 2>/dev/null
chmod 644 ~/.ssh/known_hosts

# --- Deploy to EC2 ---
echo "🚀 Deploying to $SERVER_IP with tag: $TAG"
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no ubuntu@$SERVER_IP << EOF
    set -e

    echo "🔄 Updating system..."
    sudo apt update -y && sudo apt install -y docker.io

    echo "🔐 Logging in to Docker Hub..."
    echo "$DOCKER_HUB_PASSWORD" | sudo docker login -u "$DOCKER_HUB_USERNAME" --password-stdin

    echo "🐳 Pulling image..."
    sudo docker pull $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG

    echo "🛑 Stopping old container..."
    sudo docker stop devops-app || true
    sudo docker rm devops-app || true

    echo "🚀 Starting new container..."
    sudo docker run -d -p 80:80 --name devops-app $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG

    echo "✅ Deployment successful!"
EOF

# --- Post-check ---
echo "🔍 Checking container status..."
ssh -i "$SSH_KEY" ubuntu@$SERVER_IP "sudo docker ps -f name=devops-app --format 'Running: {{.Names}} - {{.Status}}'"
