pipeline {

    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        skipDefaultCheckout(true)
        timeout(time: 20, unit: 'MINUTES')
    }

    tools {
        jdk 'JDK17'
        maven 'Maven3'
    }

    environment {

        DOCKER_EXE =
            'C:\\Users\\DELL\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'

        IMAGE_NAME = 'tasknexus-ci'

        CONTAINER_NAME = 'tasknexus-jenkins-test'

        APP_PORT = '8081'

        APP_URL = 'http://localhost:8081'
    }

    stages {

        stage('Checkout GitHub') {
            steps {

                echo '=============================================='
                echo '             CHECKOUT FROM GITHUB'
                echo '=============================================='

                checkout scm

                echo 'GitHub checkout completed successfully.'
            }
        }


        stage('Project Verification') {
            steps {

                echo '=============================================='
                echo '             PROJECT VERIFICATION'
                echo '=============================================='

                bat '''
                    echo Checking project files...
                    dir

                    if not exist "pom.xml" (
                        echo ERROR: pom.xml not found.
                        exit /b 1
                    )

                    if not exist "Dockerfile" (
                        echo ERROR: Dockerfile not found.
                        exit /b 1
                    )

                    if not exist "src" (
                        echo ERROR: src directory not found.
                        exit /b 1
                    )

                    echo.
                    echo Project files verified successfully.
                '''
            }
        }


        stage('Environment Check') {
            steps {

                echo '=============================================='
                echo '              ENVIRONMENT CHECK'
                echo '=============================================='

                echo 'Java version:'
                bat 'java -version'

                echo 'Maven version:'
                bat 'mvn -version'

                echo 'Git version:'
                bat 'git --version'

                echo 'Docker version:'
                bat '"%DOCKER_EXE%" version'

                echo 'Docker containers:'
                bat '"%DOCKER_EXE%" ps'

                echo 'Environment verification completed.'
            }
        }


        stage('Maven Clean') {
            steps {

                echo '=============================================='
                echo '                 MAVEN CLEAN'
                echo '=============================================='

                bat 'mvn clean'

                echo 'Maven clean completed.'
            }
        }


        stage('Maven Compile') {
            steps {

                echo '=============================================='
                echo '                MAVEN COMPILE'
                echo '=============================================='

                bat 'mvn compile'

                echo 'Maven compilation completed.'
            }
        }


        stage('Build WAR') {
            steps {

                echo '=============================================='
                echo '                 BUILD WAR'
                echo '=============================================='

                /*
                 * IMPORTANT:
                 * Selenium tests are NOT executed here.
                 *
                 * The application must first be packaged,
                 * placed inside Docker/Tomcat and started.
                 */

                bat 'mvn package -DskipTests'

                echo 'WAR packaging completed.'

                bat 'dir target'
            }
        }


        stage('Verify WAR') {
            steps {

                echo '=============================================='
                echo '                 VERIFY WAR'
                echo '=============================================='

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

                echo '=============================================='
                echo '               DOCKER BUILD'
                echo '=============================================='

                bat '''
                    "%DOCKER_EXE%" build ^
                    --no-cache ^
                    -t %IMAGE_NAME%:%BUILD_NUMBER% .
                '''

                echo 'Docker image created successfully.'
            }
        }


        stage('Docker Image Verification') {
            steps {

                echo '=============================================='
                echo '          DOCKER IMAGE VERIFICATION'
                echo '=============================================='

                bat '"%DOCKER_EXE%" images'

                bat '''
                    "%DOCKER_EXE%" image inspect ^
                    %IMAGE_NAME%:%BUILD_NUMBER%
                '''

                echo 'Docker image verified successfully.'
            }
        }


        stage('Remove Old Container') {
            steps {

                echo '=============================================='
                echo '            REMOVE OLD CONTAINER'
                echo '=============================================='

                bat '''
                    "%DOCKER_EXE%" rm -f %CONTAINER_NAME% 2>NUL
                    exit /b 0
                '''

                echo 'Old TaskNexus test container removed.'
            }
        }


        stage('Deploy TaskNexus') {
            steps {

                echo '=============================================='
                echo '          DEPLOY TASKNEXUS TOMCAT'
                echo '=============================================='

                bat '''
                    "%DOCKER_EXE%" run -d ^
                    --name %CONTAINER_NAME% ^
                    -p %APP_PORT%:8080 ^
                    %IMAGE_NAME%:%BUILD_NUMBER%
                '''

                echo 'TaskNexus Docker container started.'
                echo 'Application URL: %APP_URL%'
            }
        }


        stage('Container Verification') {
            steps {

                echo '=============================================='
                echo '          CONTAINER VERIFICATION'
                echo '=============================================='

                bat '"%DOCKER_EXE%" ps'

                bat '''
                    "%DOCKER_EXE%" inspect ^
                    %CONTAINER_NAME%
                '''

                echo 'Container verification completed.'
            }
        }


        stage('Wait For TaskNexus') {
            steps {

                echo '=============================================='
                echo '            WAIT FOR TASKNEXUS'
                echo '=============================================='

                powershell '''
                    $url = "$env:APP_URL/tasks"
                    $ready = $false

                    Write-Host "Waiting for TaskNexus..."
                    Write-Host "URL: $url"

                    for ($i = 1; $i -le 30; $i++) {

                        Write-Host "Attempt $i of 30"

                        try {

                            $response = Invoke-WebRequest `
                                -Uri $url `
                                -UseBasicParsing `
                                -TimeoutSec 3

                            Write-Host "HTTP Status: $($response.StatusCode)"

                            if ($response.StatusCode -eq 200) {

                                Write-Host "TaskNexus is ready."

                                $ready = $true

                                break
                            }
                        }
                        catch {

                            Write-Host "TaskNexus is still starting..."
                        }

                        Start-Sleep -Seconds 2
                    }

                    if (-not $ready) {

                        Write-Host "TaskNexus failed to start."

                        Write-Host "Docker container logs:"

                        & "$env:DOCKER_EXE" logs $env:CONTAINER_NAME

                        exit 1
                    }
                '''
            }
        }


        stage('Application Health Check') {
            steps {

                echo '=============================================='
                echo '          APPLICATION HEALTH CHECK'
                echo '=============================================='

                powershell '''
                    try {

                        $url = "$env:APP_URL/tasks"

                        $response = Invoke-WebRequest `
                            -Uri $url `
                            -UseBasicParsing `
                            -TimeoutSec 10

                        Write-Host "Application URL: $url"
                        Write-Host "HTTP Status: $($response.StatusCode)"

                        if ($response.StatusCode -ne 200) {
                            exit 1
                        }

                        Write-Host "TaskNexus health check PASSED."
                    }
                    catch {

                        Write-Host "TaskNexus health check FAILED."

                        & "$env:DOCKER_EXE" logs $env:CONTAINER_NAME

                        exit 1
                    }
                '''
            }
        }


        stage('Selenium Tests') {
            steps {

                echo '=============================================='
                echo '             SELENIUM TESTING'
                echo '=============================================='

                echo 'Running 10 Selenium test cases.'
                echo 'Selenium target: %APP_URL%'

                /*
                 * Selenium is executed ONLY AFTER
                 * Docker + Tomcat + TaskNexus are running.
                 */

                bat '''
                    mvn test ^
                    -Dheadless=true ^
                    -DbaseUrl=%APP_URL%
                '''
            }
        }


        stage('Test Report Check') {
            steps {

                echo '=============================================='
                echo '             TEST REPORT CHECK'
                echo '=============================================='

                bat '''
                    if not exist "target\\surefire-reports" (
                        echo ERROR: Surefire reports not found.
                        exit /b 1
                    )

                    echo Surefire reports found.

                    dir target\\surefire-reports
                '''
            }
        }


        stage('Final Docker Verification') {
            steps {

                echo '=============================================='
                echo '          FINAL DOCKER VERIFICATION'
                echo '=============================================='

                bat '"%DOCKER_EXE%" ps -a'

                bat '"%DOCKER_EXE%" images'

                echo 'Final Docker verification completed.'
            }
        }
    }


    post {

        always {

            echo '=============================================='
            echo '             TEST REPORTS'
            echo '=============================================='

            junit(
                testResults: 'target/surefire-reports/*.xml',
                allowEmptyResults: true
            )

            archiveArtifacts(
                artifacts: 'target/surefire-reports/*.xml',
                allowEmptyArchive: true
            )

            archiveArtifacts(
                artifacts: 'target/selenium-screenshots/*.png',
                allowEmptyArchive: true
            )

            echo 'Test reports and screenshots processed.'


            echo '=============================================='
            echo '          DOCKER CLEANUP'
            echo '=============================================='

            bat '''
                "%DOCKER_EXE%" rm -f %CONTAINER_NAME% 2>NUL
                exit /b 0
            '''

            echo 'Temporary TaskNexus container removed.'
        }


        success {

            echo '''
====================================================
       TASKNEXUS CI/CD PIPELINE SUCCESS
====================================================

GitHub Checkout       : SUCCESS
Project Verification  : SUCCESS
Environment Check     : SUCCESS
Maven Clean           : SUCCESS
Maven Compile         : SUCCESS
WAR Build             : SUCCESS
WAR Verification      : SUCCESS
Docker Build          : SUCCESS
Docker Verification   : SUCCESS
Tomcat Deployment     : SUCCESS
Application Health    : SUCCESS
Selenium Tests        : SUCCESS
JUnit Reports         : SUCCESS
Docker Cleanup        : SUCCESS

====================================================
              BUILD COMPLETED
====================================================
'''
        }


        failure {

            echo '''
====================================================
        TASKNEXUS CI/CD PIPELINE FAILED
====================================================

Check the first red stage in Console Output.

====================================================
'''
        }
    }
}