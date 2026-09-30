pipeline {

    agent any

    tools {
        jdk 'JDK17'
        maven 'Maven3'
    }

    environment {
        APP_IMAGE = 'tasknexus-ci'
        TEST_CONTAINER = 'tasknexus-jenkins-test'
        TEST_PORT = '8090'
        TEST_URL = 'http://localhost:8090'
    }

    stages {

        stage('Environment Check') {
            steps {
                echo 'Checking required tools...'

                bat 'java -version'
                bat 'mvn -version'
                bat 'git --version'
                bat 'docker version'
            }
        }

        stage('Checkout GitHub') {
            steps {
                echo 'Checking out TaskNexus source code...'

                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                echo 'Building WAR using Maven...'

                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building TaskNexus Docker image...'

                bat '''
                    docker build --no-cache ^
                    -t %APP_IMAGE%:%BUILD_NUMBER% .
                '''
            }
        }

        stage('Remove Old Test Container') {
            steps {
                powershell '''
                    docker rm -f $env:TEST_CONTAINER 2>$null
                    exit 0
                '''
            }
        }

        stage('Deploy Test Container') {
            steps {
                echo 'Starting temporary Tomcat container...'

                bat '''
                    docker run -d ^
                    --name %TEST_CONTAINER% ^
                    -p %TEST_PORT%:8080 ^
                    %APP_IMAGE%:%BUILD_NUMBER%
                '''
            }
        }

        stage('Wait For Application') {
            steps {
                echo 'Waiting for TaskNexus to become available...'

                powershell '''
                    $ready = $false

                    for ($i = 1; $i -le 30; $i++) {

                        try {

                            $response = Invoke-WebRequest `
                                -UseBasicParsing `
                                -Uri "$env:TEST_URL/tasks" `
                                -TimeoutSec 2

                            if ($response.StatusCode -eq 200) {
                                $ready = $true
                                break
                            }

                        } catch {
                        }

                        Start-Sleep -Seconds 2
                    }

                    if (-not $ready) {

                        docker logs $env:TEST_CONTAINER

                        exit 1
                    }
                '''
            }
        }

        stage('Selenium Tests') {
            steps {
                echo 'Running 10 Selenium test cases...'

                bat '''
                    mvn test ^
                    -Dheadless=true ^
                    -DbaseUrl=%TEST_URL%
                '''
            }
        }

        stage('Publish Test Results') {
            steps {
                junit testResults: 'target/surefire-reports/*.xml',
                      allowEmptyResults: false
            }
        }
    }

    post {

        success {
            echo '==================================='
            echo 'TASKNEXUS PIPELINE SUCCESSFUL'
            echo '==================================='
        }

        failure {
            echo 'TASKNEXUS PIPELINE FAILED'
        }

        always {

            archiveArtifacts artifacts: 'target/selenium-screenshots/*.png',
                             allowEmptyArchive: true

            powershell '''
                docker rm -f $env:TEST_CONTAINER 2>$null
                exit 0
            '''
        }
 
    }
}