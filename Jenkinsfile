pipeline {
    agent any

    environment {
        ACR_LOGIN_SERVER = "devopsproject1.azurecr.io"
        IMAGE_NAME = "boardgame"
        TAG = "latest"
    }

    stages {
        stage('Continuous Download') {
            steps {
                git branch: 'main', url: 'https://github.com/devops-project-manisha/Boardgame.git'
            }
        }

        stage('Continuous Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${TAG} .'
            }
        }

        stage('Login to ACR') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'acr-creds',
                    usernameVariable: 'ACR_USER',
                    passwordVariable: 'ACR_PASS'
                )]) {
                    sh '''
                        echo $ACR_PASS | docker login $ACR_LOGIN_SERVER -u $ACR_USER --password-stdin
                    '''
                }
            }
        }

        stage('Tag Image') {
            steps {
                sh '''
                    docker tag ${IMAGE_NAME}:${TAG} $ACR_LOGIN_SERVER/${IMAGE_NAME}:${TAG}
                '''
            }
        }

        stage('Push Image to ACR') {
            steps {
                sh 'docker push $ACR_LOGIN_SERVER/${IMAGE_NAME}:${TAG}'
                sh 'docker logout $ACR_LOGIN_SERVER'
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
                        ssh jenkins@4.222.234.133 \
                        ansible-playbook /home/jenkins/Myansible/board.yml \
                        -e acr_username=$ACR_USER \
                        -e acr_password=$ACR_PASS -b
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes Cluster') {
            steps {
                sh '''
                    kubectl apply -f k8s/deployment.yml
                    kubectl apply -f k8s/service.yml
                '''
            }
        }
    }
}
