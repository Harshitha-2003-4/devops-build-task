pipeline {
    agent any

    environment {
        DOCKER_HUB_USERNAME = 'harshithaa2003'
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        IMAGE_NAME = 'devops-app'
        GITHUB_CREDENTIALS = credentials('github-token')
        SERVER_IP = '13.233.45.123'   // ✅ your EC2 app server's public IP
    }

    stages {
        stage('Detect Branch') {
            steps {
                script {
                    env.ACTUAL_BRANCH_NAME = 'master' // or detect dynamically
                    echo "🔍 Branch Name: ${env.ACTUAL_BRANCH_NAME}"
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_HUB_CREDENTIALS_USR',
                        passwordVariable: 'DOCKER_HUB_CREDENTIALS_PSW'
                    )
                ]) {
                    sh '''
                        export DOCKER_HUB_CREDENTIALS_USR=$DOCKER_HUB_CREDENTIALS_USR
                        export DOCKER_HUB_CREDENTIALS_PSW=$DOCKER_HUB_CREDENTIALS_PSW
                        ./build.sh ${ACTUAL_BRANCH_NAME}
                    '''
                }
            }
        }

        stage('Deploy to EC2 Server') {
            when {
                expression { env.ACTUAL_BRANCH_NAME == 'master' }
            }
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'ec2-ssh-key',
                        keyFileVariable: 'SSH_KEY'
                    ),
                    usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_HUB_USERNAME',
                        passwordVariable: 'DOCKER_HUB_PASSWORD'
                    )
                ]) {
                    sh '''
                        chmod 600 $SSH_KEY
                        export DOCKER_HUB_USERNAME=$DOCKER_HUB_USERNAME
                        export DOCKER_HUB_PASSWORD=$DOCKER_HUB_PASSWORD
                        export SSH_KEY=$SSH_KEY
                        export SERVER_IP=$SERVER_IP
                        ./deploy.sh ${ACTUAL_BRANCH_NAME}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ All stages completed!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}

