pipeline {

    agent any

    tools {
        jdk 'JDK17'
        maven 'Maven3'
    }

    environment {

        DOCKER_EXE = 'C:\\Users\\DELL\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'

        APP_IMAGE = 'tasknexus-ci'

        CONTAINER_NAME = 'tasknexus-jenkins-test'

        APP_PORT = '8090'

        APP_URL = 'http://localhost:8090'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out TaskNexus source code...'

                git(
                    branch: 'main',
                    url: 'https://github.com/RautAtharv/JavaWebApp-CICD.git'
                )
            }
        }

        stage('Environment Check') {
            steps {
                echo 'Checking Java...'
                bat 'java -version'

                echo 'Checking Maven...'
                bat 'mvn -version'

                echo 'Checking Git...'
                bat 'git --version'

                echo 'Checking Docker...'
                bat '"%DOCKER_EXE%" version'

                echo 'Checking Docker containers...'
                bat '"%DOCKER_EXE%" ps'
            }
        }

        stage('Maven Clean') {
            steps {
                echo 'Running Maven clean...'

                bat 'mvn clean'
            }
        }

        stage('Maven Compile') {
            steps {
                echo 'Compiling TaskNexus...'

                bat 'mvn compile'
            }
        }

        stage('Maven Unit Tests') {
            steps {
                echo 'Running Maven unit tests...'

                bat 'mvn test'
            }
        }

        stage('Build WAR') {
            steps {
                echo 'Creating TaskNexus WAR file...'

                bat 'mvn package -DskipTests'

                echo 'Contents of target directory:'

                bat 'dir target'
            }
        }

        stage('Verify WAR') {
            steps {
                bat '''
                    if not exist "target\\JavaWebApp.war" (
                        echo ERROR: target\\JavaWebApp.war was not created.
                        echo Available files:
                        dir target
                        exit /b 1
                    )

                    echo SUCCESS: JavaWebApp.war found.
                '''
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building TaskNexus Docker image...'

                bat '''
                    "%DOCKER_EXE%" build ^
                    --no-cache ^
                    -t %APP_IMAGE%:%BUILD_NUMBER% .
                '''
            }
        }

        stage('Docker Image Check') {
            steps {
                echo 'Verifying Docker image...'

                bat '"%DOCKER_EXE%" images'

                bat '''
                    "%DOCKER_EXE%" image inspect %APP_IMAGE%:%BUILD_NUMBER%
                '''
            }
        }

        stage('Remove Old Container') {
            steps {
                echo 'Removing previous Jenkins test container...'

                bat '''
                    "%DOCKER_EXE%" rm -f %CONTAINER_NAME% 2>NUL
                    exit /b 0
                '''
            }
        }

        stage('Deploy TaskNexus') {
            steps {
                echo 'Starting TaskNexus Tomcat container...'

                bat '''
                    "%DOCKER_EXE%" run -d ^
                    --name %CONTAINER_NAME% ^
                    -p %APP_PORT%:8080 ^
                    %APP_IMAGE%:%BUILD_NUMBER%
                '''
            }
        }

        stage('Container Check') {
            steps {
                echo 'Checking running TaskNexus container...'

                bat '"%DOCKER_EXE%" ps'

                bat '"%DOCKER_EXE%" ps -a'
            }
        }

        stage('Wait For Application') {
            steps {
                echo 'Waiting for TaskNexus to start...'

                powershell '''
                    $url = $env:APP_URL
                    $ready = $false

                    for ($i = 1; $i -le 30; $i++) {

                        Write-Host "Checking TaskNexus - attempt $i of 30"

                        try {
                            $response = Invoke-WebRequest `
                                -Uri "$url/tasks" `
                                -UseBasicParsing `
                                -TimeoutSec 3

                            if ($response.StatusCode -eq 200) {
                                Write-Host "TaskNexus is running."
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
                        Write-Host "TaskNexus did not start successfully."
                        exit 1
                    }
                '''
            }
        }

        stage('Application Health Check') {
            steps {
                echo 'Checking TaskNexus web application...'

                powershell '''
                    try {

                        $response = Invoke-WebRequest `
                            -Uri "$env:APP_URL/tasks" `
                            -UseBasicParsing `
                            -TimeoutSec 10

                        Write-Host "HTTP Status Code: $($response.StatusCode)"

                        if ($response.StatusCode -ne 200) {
                            exit 1
                        }

                        Write-Host "Application health check passed."
                    }
                    catch {

                        Write-Host "Application health check failed."
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
                    -DbaseUrl=%APP_URL%
                '''
            }
        }

        stage('Publish Test Results') {
            steps {
                echo 'Publishing JUnit/Selenium test results...'

                junit(
                    testResults: 'target/surefire-reports/*.xml',
                    allowEmptyResults: false
                )
            }
        }

        stage('Archive Screenshots') {
            steps {
                echo 'Archiving Selenium screenshots...'

                archiveArtifacts(
                    artifacts: 'target/selenium-screenshots/*.png',
                    allowEmptyArchive: true
                )
            }
        }

        stage('Final Verification') {
            steps {
                echo 'Final Docker verification...'

                bat '"%DOCKER_EXE%" ps -a'

                bat '"%DOCKER_EXE%" images'

                echo 'TaskNexus CI pipeline verification completed.'
            }
        }
    }

    post {

        success {
            echo '''
==================================================
        TASKNEXUS PIPELINE SUCCESSFUL
==================================================

GitHub Checkout       : SUCCESS
Java 17               : SUCCESS
Maven                 : SUCCESS
Compilation           : SUCCESS
Unit Tests            : SUCCESS
WAR Packaging         : SUCCESS
Docker Build          : SUCCESS
Docker Image Check    : SUCCESS
Tomcat Deployment     : SUCCESS
Application Health    : SUCCESS
Selenium Tests        : SUCCESS
JUnit Results         : SUCCESS

==================================================
              BUILD COMPLETED
==================================================
'''
        }

        failure {
            echo '''
==================================================
          TASKNEXUS PIPELINE FAILED
==================================================

Check the Console Output for the first failed stage.

==================================================
'''
        }

        always {
            echo 'Performing cleanup...'

            bat '''
                "%DOCKER_EXE%" rm -f %CONTAINER_NAME% 2>NUL
                exit /b 0
            '''
        }
    }
}