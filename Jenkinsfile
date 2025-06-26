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
                    env.ACTUAL_BRANCH_NAME = env.BRANCH_NAME ?: sh(
                        script: "git rev-parse --abbrev-ref HEAD",
                        returnStdout: true
                    ).trim()
                    echo "🔍 Branch Name: ${env.ACTUAL_BRANCH_NAME}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "./build.sh ${env.ACTUAL_BRANCH_NAME}"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "✅ Image already pushed during build.sh"
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    def branch = env.ACTUAL_BRANCH_NAME
                    if (branch == 'master') {
                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                            sh """
                                chmod 600 \$SSH_KEY
                                ./deploy.sh prod
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
