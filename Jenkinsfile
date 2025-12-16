pipeline {
    agent any

    environment {
        ACR_LOGIN_SERVER = "devopsproject1.azurecr.io"
        IMAGE_NAME = "boardgame-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/palwalun/Boardgame.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Login to ACR') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'acr-creds',
                    usernameVariable: 'ACR_USER',
                    passwordVariable: 'ACR_PASS'
                )]) {
                    sh """
                    echo \$ACR_PASS | docker login ${ACR_LOGIN_SERVER} \
                    -u \$ACR_USER --password-stdin
                    """
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} \
                ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Tag Image as latest') {
            steps {
                sh """
                docker tag ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG} \
                ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest
                """
            }
        }

        stage('Push Images to ACR') {
            steps {
                sh """
                docker push ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}
                docker push ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest
                """
            }
        }

        stage('Deploy Docker Image to QA Server') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'acr-creds',
                    usernameVariable: 'ACR_USER',
                    passwordVariable: 'ACR_PASS'
                )]) {
                    sh '''
                    set -e
                    ssh -o StrictHostKeyChecking=no jenkins@4.222.234.133 \
                    ansible-playbook /home/jenkins/Myansible/board.yml \
                    -e acr_username=$ACR_USER \
                    -e acr_password=$ACR_PASS \
                    -b
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout devopsproject1.azurecr.io || true'
        }
    }
}
