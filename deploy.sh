#!/bin/bash
set -e

BRANCH=$1
SERVER_IP="${SERVER_IP:-13.233.45.123}"  # default if not passed
SSH_KEY="${SSH_KEY}"
DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME}"
DOCKER_HUB_PASSWORD="${DOCKER_HUB_PASSWORD}"

if [[ -z "$SSH_KEY" || -z "$SERVER_IP" || -z "$DOCKER_HUB_USERNAME" || -z "$DOCKER_HUB_PASSWORD" ]]; then
    echo "❌ Missing required environment variables"
    exit 1
fi

echo "✅ Adding server to known_hosts..."
ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" ubuntu@"$SERVER_IP" "echo Connected!"

echo "🚀 Deploying to $SERVER_IP"
ssh -i "$SSH_KEY" ubuntu@"$SERVER_IP" << EOF
    echo "🔑 Logging into Docker Hub..."
    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin

    echo "🐳 Pulling latest Docker image..."
    docker pull $DOCKER_HUB_USERNAME/devops-app:$BRANCH

    echo "🛑 Removing old container (if exists)..."
    docker rm -f devops-app || true

    echo "🚀 Running new container..."
    docker run -d --name devops-app -p 80:80 $DOCKER_HUB_USERNAME/devops-app:$BRANCH
EOF

echo "✅ Deployment complete!"

