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
                    def branch = env.BRANCH_NAME ?: env.GIT_BRANCH ?: 'unknown'
                    if (branch == 'master') {
                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                            sh '''
                                echo "Deploying to server..."
                                chmod 600 $SSH_KEY
                                ssh -o StrictHostKeyChecking=no -i $SSH_KEY ec2-user@your-server-ip "bash -s" < ./deploy.sh
                            '''
                        }
                    }
                }
            }
        }
    }
}
