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
                    url: 'https://github.com/devops-project-manisha/Boardgame.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build image') {
            steps {
                sh 'docker build -t boardgame-app:latest .'
            }
        }

        stage('Tag Image') {
            steps {
                sh """
                docker tag boardgame-app:latest $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG
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
                    echo $ACR_PASS | docker login $ACR_LOGIN_SERVER -u $ACR_USER --password-stdin
                    """
                }
            }
        }

        stage('push Image') {
            steps {
                sh """
                docker push $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG
                """
            }
        }

        stage('Deploy using Ansible') {
            steps {
                sh '''
                ssh -o StrictHostKeyChecking=no jenkins@4.222.234.133 \
                ansible-playbook /home/jenkins/Myansible/boardapp.yml -b
                '''
            }
        }
    }
}
