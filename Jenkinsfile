pipeline {
    agent any

    environment {
        DOCKER_HUB_USERNAME = 'Harshithaa2003'
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        IMAGE_NAME = 'devops-app'
        GITHUB_CREDENTIALS = credentials('github-token')
    }

    stages {
        stage('Detect Branch') {
            steps {
                script {
                    // Force master for now to avoid "HEAD" issues
                    env.ACTUAL_BRANCH_NAME = 'master'
                    echo "🔍 Branch Name: ${env.ACTUAL_BRANCH_NAME}"
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_HUB_CREDENTIALS_USR', passwordVariable: 'DOCKER_HUB_CREDENTIALS_PSW')
                ]) {
                    sh """
                        export DOCKER_HUB_CREDENTIALS_USR=\$DOCKER_HUB_CREDENTIALS_USR
                        export DOCKER_HUB_CREDENTIALS_PSW=\$DOCKER_HUB_CREDENTIALS_PSW
                        ./build.sh \${ACTUAL_BRANCH_NAME}
                    """
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    def branch = env.ACTUAL_BRANCH_NAME
                    if (branch == 'master') {
                        withCredentials([
                            sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY'),
                            usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')
                        ]) {
                            sh """
                                chmod 600 \$SSH_KEY
                                DOCKER_HUB_USERNAME=\$DOCKER_HUB_USERNAME \\
                                DOCKER_HUB_PASSWORD=\$DOCKER_HUB_PASSWORD \\
                                SSH_KEY=\$SSH_KEY ./deploy.sh prod
                            """
                        }
                    } else {
                        echo "🟡 Skipping deployment for branch: ${branch}"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check the logs."
        }
    }
}
