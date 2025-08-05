pipeline {
    agent any

    environment {
        DOCKER_HUB_USERNAME = 'harshithaa2003'
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        IMAGE_NAME = 'devops-app'
        GITHUB_CREDENTIALS = credentials('github-token')
    }

    stages {
        stage('Detect Branch') {
            steps {
                script {
                    env.ACTUAL_BRANCH_NAME = 'master' // or detect dynamically if needed
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
                        ./build.sh master
                    '''
                }
            }
        }

        stage('Deploy to EC2 Server') {
            steps {
                script {
                    if (env.ACTUAL_BRANCH_NAME == 'master') {
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
                                ./deploy.sh master
                            '''
                        }
                    } else {
                        echo "🟡 Skipping deploy for non-master branch"
                    }
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
