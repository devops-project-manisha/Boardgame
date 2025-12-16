pipeline {
    agent any

    tools {
        jdk 'JAVA21'
        maven 'Maven 3.9.11'
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
    }
}
