pipeline {

    agent any

    tools {
        jdk 'JDK17'
        maven 'Maven3'
    }

    environment {

        // Docker Desktop CLI path
        PATH+DOCKER = 'C:\\Users\\DELL\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin'

        // TaskNexus Docker configuration
        APP_IMAGE = 'tasknexus-ci'
        TEST_CONTAINER = 'tasknexus-jenkins-test'

        // Jenkins test port
        TEST_PORT = '8090'

        // Application URL used by Selenium
        TEST_URL = 'http://localhost:8090'
    }

    stages {

        stage('Environment Check') {

            steps {

                echo '=========================================='
                echo '        TASKNEXUS ENVIRONMENT CHECK'
                echo '=========================================='

                echo 'Checking Java...'
                bat 'java -version'

                echo 'Checking Maven...'
                bat 'mvn -version'

                echo 'Checking Git...'
                bat 'git --version'

                echo 'Checking Docker...'
                bat 'docker version'

                echo 'Checking Docker Containers...'
                bat 'docker ps'
            }
        }


        stage('Checkout GitHub') {

            steps {

                echo '=========================================='
                echo '          CHECKOUT FROM GITHUB'
                echo '=========================================='

                git branch: 'main',
                    url: 'https://github.com/RautAtharv/JavaWebApp-CICD.git'

                echo 'GitHub source code downloaded successfully.'
            }
        }


        stage('Maven Clean Build') {

            steps {

                echo '=========================================='
                echo '             MAVEN BUILD'
                echo '=========================================='

                bat 'mvn clean'
            }
        }


        stage('Compile') {

            steps {

                echo '=========================================='
                echo '              MAVEN COMPILE'
                echo '=========================================='

                bat 'mvn compile'
            }
        }


        stage('Package WAR') {

            steps {

                echo '=========================================='
                echo '             WAR PACKAGING'
                echo '=========================================='

                bat 'mvn package -DskipTests'

                echo 'Checking target directory...'

                bat 'dir target'
            }
        }


        stage('Verify WAR') {

            steps {

                echo '=========================================='
                echo '             VERIFYING WAR'
                echo '=========================================='

                bat '''
                    if not exist "target\\JavaWebApp.war" (
                        echo ERROR: JavaWebApp.war was not created.
                        exit /b 1
                    )

                    echo SUCCESS: JavaWebApp.war exists.
                '''
            }
        }


        stage('Docker Build') {

            steps {

                echo '=========================================='
                echo '             DOCKER BUILD'
                echo '=========================================='

                bat '''
                    docker build --no-cache ^
                    -t %APP_IMAGE%:%BUILD_NUMBER% .
                '''

                echo 'Docker image created successfully.'
            }
        }


        stage('Docker Image Check') {

            steps {

                echo '=========================================='
                echo '          DOCKER IMAGE VERIFICATION'
                echo '=========================================='

                bat 'docker images'

                bat '''
                    docker image inspect %APP_IMAGE%:%BUILD_NUMBER%
                '''
            }
        }


        stage('Remove Old Test Container') {

            steps {

                echo '=========================================='
                echo '       REMOVING OLD TEST CONTAINER'
                echo '=========================================='

                powershell '''
                    $ErrorActionPreference = "SilentlyContinue"

                    docker rm -f $env:TEST_CONTAINER | Out-Null

                    Write-Host "Old test container removed if it existed."

                    exit 0
                '''
            }
        }


        stage('Deploy Test Container') {

            steps {

                echo '=========================================='
                echo '        DEPLOYING TASKNEXUS CONTAINER'
                echo '=========================================='

                bat '''
                    docker run -d ^
                    --name %TEST_CONTAINER% ^
                    -p %TEST_PORT%:8080 ^
                    %APP_IMAGE%:%BUILD_NUMBER%
                '''

                echo 'TaskNexus test container started.'
            }
        }


        stage('Container Verification') {

            steps {

                echo '=========================================='
                echo '        CONTAINER VERIFICATION'
                echo '=========================================='

                bat 'docker ps'

                bat '''
                    docker inspect %TEST_CONTAINER%
                '''
            }
        }


        stage('Wait For Tomcat') {

            steps {

                echo '=========================================='
                echo '       WAITING FOR TOMCAT APPLICATION'
                echo '=========================================='

                powershell '''

                    $ready = $false

                    for ($i = 1; $i -le 30; $i++) {

                        Write-Host "Checking TaskNexus - attempt $i of 30"

                        try {

                            $response = Invoke-WebRequest `
                                -UseBasicParsing `
                                -Uri "$env:TEST_URL/tasks" `
                                -TimeoutSec 3

                            if ($response.StatusCode -eq 200) {

                                Write-Host "TaskNexus is available."
                                $ready = $true

                                break
                            }

                        }
                        catch {

                            Write-Host "Application is still starting..."
                        }

                        Start-Sleep -Seconds 2
                    }


                    if (-not $ready) {

                        Write-Host "ERROR: TaskNexus did not start."

                        docker logs $env:TEST_CONTAINER

                        exit 1
                    }
                '''
            }
        }


        stage('Application Health Check') {

            steps {

                echo '=========================================='
                echo '        APPLICATION HEALTH CHECK'
                echo '=========================================='

                powershell '''

                    try {

                        $response = Invoke-WebRequest `
                            -UseBasicParsing `
                            -Uri "$env:TEST_URL/tasks" `
                            -TimeoutSec 10

                        Write-Host "HTTP Status Code: $($response.StatusCode)"

                        if ($response.StatusCode -ne 200) {

                            Write-Host "Application health check failed."

                            exit 1
                        }

                        Write-Host "TaskNexus health check successful."
                    }

                    catch {

                        Write-Host "Unable to access TaskNexus."

                        exit 1
                    }
                '''
            }
        }


        stage('Selenium Tests') {

            steps {

                echo '=========================================='
                echo '        RUNNING SELENIUM TESTS'
                echo '=========================================='

                echo 'Running 10 automated Selenium test cases...'

                bat '''
                    mvn test ^
                    -Dheadless=true ^
                    -DbaseUrl=%TEST_URL%
                '''
            }
        }


        stage('Selenium Test Results') {

            steps {

                echo '=========================================='
                echo '        PUBLISHING TEST RESULTS'
                echo '=========================================='

                junit(
                    testResults: 'target/surefire-reports/*.xml',
                    allowEmptyResults: false
                )
            }
        }


        stage('Final Docker Verification') {

            steps {

                echo '=========================================='
                echo '       FINAL DOCKER VERIFICATION'
                echo '=========================================='

                bat 'docker ps -a'

                bat 'docker images'

                echo '=========================================='
                echo '       TASKNEXUS BUILD COMPLETED'
                echo '=========================================='
            }
        }
    }


    post {

        success {

            echo '=========================================='
            echo '       TASKNEXUS PIPELINE SUCCESS'
            echo '=========================================='

            echo 'GitHub Checkout       : SUCCESS'
            echo 'Java/JDK              : SUCCESS'
            echo 'Maven Build           : SUCCESS'
            echo 'WAR Packaging         : SUCCESS'
            echo 'Docker Build          : SUCCESS'
            echo 'Tomcat Deployment     : SUCCESS'
            echo 'Application Check     : SUCCESS'
            echo 'Selenium Tests        : SUCCESS'
            echo 'JUnit Results         : SUCCESS'

            echo '=========================================='
        }


        failure {

            echo '=========================================='
            echo '       TASKNEXUS PIPELINE FAILED'
            echo '=========================================='

            echo 'Check the failed stage in Console Output.'

            powershell '''

                $ErrorActionPreference = "SilentlyContinue"

                docker ps -a

                docker logs $env:TEST_CONTAINER

                exit 0
            '''
        }


        always {

            echo '=========================================='
            echo '       POST BUILD CLEANUP'
            echo '=========================================='

            archiveArtifacts(
                artifacts: 'target/surefire-reports/*.xml',
                allowEmptyArchive: true
            )

            archiveArtifacts(
                artifacts: 'target/selenium-screenshots/*.png',
                allowEmptyArchive: true
            )

            powershell '''

                $ErrorActionPreference = "SilentlyContinue"

                docker rm -f $env:TEST_CONTAINER | Out-Null

                Write-Host "Test container cleanup completed."

                exit 0
            '''
        }
    }
    
}