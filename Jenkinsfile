pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                bat 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                bat 'mvn test'
            }
        }

        stage('Package WAR') {
            steps {
                bat 'mvn package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t javawebapp:1.0 .'
            }
        }

        stage('Deploy') {
            steps {
                bat 'docker rm -f javawebapp || exit 0'
                bat 'docker run -d --name javawebapp -p 8081:8080 javawebapp:1.0'
            }
        }

        stage('Health Check') {
            steps {
                echo 'Checking application health...'

                retry(5) {
                    sleep time: 5, unit: 'SECONDS'
                    bat 'curl --fail http://localhost:8081/'
                }

                echo 'Application is running successfully!'
            }
        }
    }

    post {

        success {
            echo '======================================'
            echo 'CI/CD PIPELINE COMPLETED SUCCESSFULLY!'
            echo 'Application: http://localhost:8081/'
            echo '======================================'
        }

        failure {
            echo 'CI/CD PIPELINE FAILED!'
        }
    }
}