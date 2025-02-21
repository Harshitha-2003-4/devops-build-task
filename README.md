# DevOps Application Deployment Capstone

This project demonstrates a CI/CD pipeline for building, testing, and deploying a React application using Jenkins, Docker, and AWS EC2. The pipeline automates the process of building Docker images, pushing them to Docker Hub, and deploying the application to an EC2 instance.

## Project Overview

This project automates the following tasks:

- **Build**: Builds a Docker image for a React application.
- **Push**: Pushes the Docker image to Docker Hub.
  - Images are tagged as `dev` for the `dev` branch and `prod` for the `master` branch.
- **Deploy**: Deploys the application to an AWS EC2 instance.
  - The `master` branch triggers deployment to the production environment.

## Prerequisites

Before setting up the project, ensure you have the following:

### GitHub Repository

- A GitHub repository with the project code.
- Two branches: `dev` and `master`.

### Jenkins

- Jenkins installed and configured.
- Required plugins:
  - GitHub Integration
  - Docker Pipeline
  - Credentials Plugin

### Docker Hub

- A Docker Hub account.
- Two repositories: `dev` (public) and `prod` (private).

### AWS EC2 Instance

- An EC2 instance running Ubuntu.
- Docker installed on the instance.
- Security group configured to allow HTTP traffic on port 80 and SSH access.

### SSH Key

- An SSH key pair for accessing the EC2 instance.

## Setup Instructions

### Local Setup

Clone the repository:

```bash
git clone https://github.com/manjunath-start/devops-build-task.git
cd devops-build-task
```

Install dependencies:

```bash
npm install
```

Build the React application:

```bash
npm run build
```

Build the Docker image:

```bash
docker build -t manjunathdc/devops-app:dev .
```

Run the Docker container locally:

```bash
docker run -d -p 80:80 --name devops-app manjunathdc/devops-app:dev
```

Access the application:  
[http://localhost:80](http://localhost:80)

### Jenkins Setup

#### Install Jenkins

Follow the official Jenkins installation guide.

#### Install Required Plugins

Go to **Manage Jenkins > Manage Plugins** and install:

- GitHub Integration
- Docker Pipeline
- Credentials Plugin

#### Configure GitHub Webhook

1. Go to your GitHub repository.
2. Navigate to **Settings > Webhooks**.
3. Add a new webhook:
   - **Payload URL**: `http://<your-jenkins-server-ip>:8080/github-webhook/`
   - **Content type**: `application/json`.
   - **Trigger**: Select **Just the push event**.

#### Add Credentials

Go to **Manage Jenkins > Manage Credentials** and add:

- Docker Hub credentials (username and password).
- SSH key for the EC2 instance.

#### Create a Multibranch Pipeline

1. Go to **New Item** in Jenkins.
2. Enter a name for your pipeline (e.g., `DevOps-Build-Deploy-Multibranch`).
3. Select **Multibranch Pipeline** and configure:
   - **Branch Sources**: Add your GitHub repository.
   - **Scan Multibranch Pipeline Triggers**: Set up automatic branch scanning.

### AWS EC2 Setup

#### Launch an EC2 Instance

- Use an **Ubuntu AMI**.
- Configure the security group to allow HTTP traffic on **port 80** and **SSH access**.

#### Install Docker

```bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
```

#### Add the Jenkins User to the Docker Group

```bash
sudo usermod -aG docker ubuntu
```

#### Restart Docker

```bash
sudo systemctl restart docker
```

## Pipeline Workflow

1. **Push to `dev` Branch**  
   - Jenkins builds the Docker image and pushes it to the `dev` repository on Docker Hub.

2. **Merge `dev` into `master`**  
   - Jenkins builds the Docker image and pushes it to the `prod` repository on Docker Hub.
   - Jenkins deploys the application to the EC2 instance.
