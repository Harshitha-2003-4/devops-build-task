#!/bin/bash

set -e

DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME:-harshithaa2003}"
DOCKER_HUB_PASSWORD="${DOCKER_HUB_PASSWORD:-}"
IMAGE_NAME="devops-app"
TAG="${1:-dev}"
SERVER_IP="YOUR_EC2_PUBLIC_IP"  # 👈 Replace this with actual IP
SSH_KEY="$SSH_KEY"

if [[ ! -f "$SSH_KEY" ]]; then
    echo "❌ SSH key not found: $SSH_KEY"
    exit 1
fi

# Add EC2 host to known_hosts to avoid SSH prompt
echo "✅ Adding server to known_hosts..."
mkdir -p ~/.ssh
ssh-keyscan -H $SERVER_IP >> ~/.ssh/known_hosts 2>/dev/null
chmod 644 ~/.ssh/known_hosts

echo "🚀 Deploying to $SERVER_IP"
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no ubuntu@$SERVER_IP << EOF
    set -e
    echo "🔄 Installing Docker if missing..."
    sudo apt update -y && sudo apt install -y docker.io

    echo "🔐 Logging into Docker Hub..."
    echo "$DOCKER_HUB_PASSWORD" | sudo docker login -u "$DOCKER_HUB_USERNAME" --password-stdin

    echo "🐳 Pulling new image..."
    sudo docker pull $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG

    echo "🛑 Stopping old container..."
    sudo docker stop devops-app || true
    sudo docker rm devops-app || true

    echo "🚀 Starting container on port 80..."
    sudo docker run -d -p 80:80 --name devops-app $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG

    echo "✅ Deployment successful!"
EOF

ssh -i "$SSH_KEY" ubuntu@$SERVER_IP "sudo docker ps -f name=devops-app --format '🟢 Running: {{.Names}} - {{.Status}}'"
