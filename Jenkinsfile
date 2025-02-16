pipeline {
    agent any

    environment {
        DOCKER_HUB_USERNAME = 'manjunathdc'
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        IMAGE_NAME = 'devops-app'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh './build.sh'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker tag ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:dev"
                        sh "docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:dev"
                    } else if (env.BRANCH_NAME == 'master') {
                        sh "docker tag ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:prod"
                        sh "docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:prod"
                    }
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    sh './deploy.sh'
                }
            }
        }
    }
}
