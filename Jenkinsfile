pipeline {
    agent any

    environment {
        DOCKER_HUB_USERNAME = 'manjunathdc'
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials') // Ensure this matches the credential ID
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
                    if (BRANCH_NAME == 'dev') {
                        sh "docker tag ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:dev"
                        sh "docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:dev"
                    } else if (BRANCH_NAME == 'master') {
                        sh "docker tag ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:prod"
                        sh "docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:prod"
                    }
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    if (BRANCH_NAME == 'master') {
                        // Load the SSH key from Jenkins credentials
                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                            sh '''
                                echo "SSH Key Path: $SSH_KEY"
                                ls -l $SSH_KEY
                                chmod 600 $SSH_KEY
                                ./deploy.sh
                            '''
                        }
                    } else {
                        echo "Skipping deployment for branch: ${BRANCH_NAME}"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check the logs for details."
        }
    }
}