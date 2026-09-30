pipeline {

    agent any

    tools {
        jdk 'JDK17'
        maven 'Maven3'
    }

    environment {

        DOCKER_EXE =
            'C:\\Users\\DELL\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'

        APP_NAME = 'TaskNexus'

        APP_IMAGE = 'tasknexus-ci'

        TEST_CONTAINER = 'tasknexus-jenkins-test'

        TEST_PORT = '8090'

        TEST_URL = 'http://localhost:8090'

        WAR_FILE = 'target\\JavaWebApp.war'
    }


    stages {


        stage('Project Information') {

            steps {

                echo '=================================================='
                echo '              TASKNEXUS PRO CI/CD'
                echo '=================================================='

                echo 'Application : TaskNexus Pro'
                echo 'Technology  : Java 17 / Servlet / JSP'
                echo 'Build Tool  : Maven'
                echo 'Server      : Apache Tomcat'
                echo 'Container   : Docker'
                echo 'Testing     : Selenium WebDriver'
                echo 'CI Tool     : Jenkins'
                echo 'Source      : GitHub'

                echo '=================================================='
            }
        }


        stage('Checkout GitHub') {

            steps {

                echo '=================================================='
                echo '              GITHUB CHECKOUT'
                echo '=================================================='

                git(
                    branch: 'main',
                    url: 'https://github.com/RautAtharv/JavaWebApp-CICD.git'
                )

                echo 'GitHub repository checked out successfully.'
            }
        }


        stage('Verify Project Files') {

            steps {

                echo '=================================================='
                echo '             VERIFY PROJECT FILES'
                echo '=================================================='

                bat 'dir'

                echo 'Checking pom.xml...'

                bat '''
                    if not exist "pom.xml" (
                        echo ERROR: pom.xml not found.
                        exit /b 1
                    )

                    echo pom.xml found.
                '''


                echo 'Checking Dockerfile...'

                bat '''
                    if not exist "Dockerfile" (
                        echo ERROR: Dockerfile not found.
                        exit /b 1
                    )

                    echo Dockerfile found.
                '''


                echo 'Checking source directory...'

                bat '''
                    if not exist "src" (
                        echo ERROR: src directory not found.
                        exit /b 1
                    )

                    echo src directory found.
                '''
            }
        }


        stage('Environment Check') {

            steps {

                echo '=================================================='
                echo '             ENVIRONMENT CHECK'
                echo '=================================================='


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


                echo 'Environment verification completed.'
            }
        }


        stage('Maven Clean') {

            steps {

                echo '=================================================='
                echo '                 MAVEN CLEAN'
                echo '=================================================='

                bat 'mvn clean'

                echo 'Maven clean completed successfully.'
            }
        }


        stage('Maven Compile') {

            steps {

                echo '=================================================='
                echo '                MAVEN COMPILE'
                echo '=================================================='

                bat 'mvn compile'

                echo 'Compilation completed successfully.'
            }
        }


        stage('Maven Unit Test') {

            steps {

                echo '=================================================='
                echo '               MAVEN UNIT TEST'
                echo '=================================================='

                bat 'mvn test -DskipTests=false'

                echo 'Maven test stage completed.'
            }
        }


        stage('Build WAR') {

            steps {

                echo '=================================================='
                echo '                 WAR PACKAGING'
                echo '=================================================='

                bat 'mvn package -DskipTests'

                echo 'Maven packaging completed.'

                bat 'dir target'
            }
        }


        stage('Verify WAR File') {

            steps {

                echo '=================================================='
                echo '                 VERIFY WAR'
                echo '=================================================='

                bat '''
                    if not exist "target\\JavaWebApp.war" (
                        echo.
                        echo ==============================================
                        echo ERROR: JavaWebApp.war NOT FOUND
                        echo ==============================================
                        echo.
                        dir target
                        exit /b 1
                    )

                    echo.
                    echo ==============================================
                    echo SUCCESS: JavaWebApp.war FOUND
                    echo ==============================================
                    echo.
                '''
            }
        }


        stage('Docker Information') {

            steps {

                echo '=================================================='
                echo '               DOCKER INFORMATION'
                echo '=================================================='

                bat '"%DOCKER_EXE%" version'

                bat '"%DOCKER_EXE%" info'
            }
        }


        stage('Docker Build') {

            steps {

                echo '=================================================='
                echo '                DOCKER BUILD'
                echo '=================================================='

                bat '''
                    "%DOCKER_EXE%" build ^
                    --no-cache ^
                    -t %APP_IMAGE%:%BUILD_NUMBER% .
                '''

                echo 'Docker image built successfully.'
            }
        }


        stage('Docker Image Verification') {

            steps {

                echo '=================================================='
                echo '            DOCKER IMAGE VERIFICATION'
                echo '=================================================='

                bat '"%DOCKER_EXE%" images'

                bat '''
                    "%DOCKER_EXE%" image inspect ^
                    %APP_IMAGE%:%BUILD_NUMBER%
                '''

                echo 'Docker image verification completed.'
            }
        }


        stage('Remove Existing Test Container') {

            steps {

                echo '=================================================='
                echo '           REMOVE OLD TEST CONTAINER'
                echo '=================================================='

                bat '''
                    "%DOCKER_EXE%" rm -f ^
                    %TEST_CONTAINER% 2>NUL

                    exit /b 0
                '''

                echo 'Old test container removed if it existed.'
            }
        }


        stage('Deploy TaskNexus Container') {

            steps {

                echo '=================================================='
                echo '             DEPLOY TASKNEXUS'
                echo '=================================================='

                bat '''
                    "%DOCKER_EXE%" run -d ^
                    --name %TEST_CONTAINER% ^
                    -p %TEST_PORT%:8080 ^
                    %APP_IMAGE%:%BUILD_NUMBER%
                '''

                echo 'TaskNexus container started.'
            }
        }


        stage('Container Status') {

            steps {

                echo '=================================================='
                echo '             CONTAINER STATUS'
                echo '=================================================='

                bat '"%DOCKER_EXE%" ps'

                bat '"%DOCKER_EXE%" ps -a'

                echo 'Container status verified.'
            }
        }


        stage('Container Details') {

            steps {

                echo '=================================================='
                echo '            CONTAINER DETAILS'
                echo '=================================================='

                bat '''
                    "%DOCKER_EXE%" inspect ^
                    %TEST_CONTAINER%
                '''
            }
        }


        stage('Wait For Tomcat') {

            steps {

                echo '=================================================='
                echo '             WAIT FOR TOMCAT'
                echo '=================================================='

                powershell '''

                    $ready = $false

                    Write-Host "Waiting for TaskNexus..."

                    for ($i = 1; $i -le 30; $i++) {

                        Write-Host "Application check $i / 30"

                        try {

                            $response = Invoke-WebRequest `
                                -UseBasicParsing `
                                -Uri "$env:TEST_URL/tasks" `
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

                        Write-Host "===================================="
                        Write-Host "TASKNEXUS STARTUP FAILED"
                        Write-Host "===================================="

                        & "$env:DOCKER_EXE" logs $env:TEST_CONTAINER

                        exit 1
                    }

                    Write-Host "TaskNexus startup successful."
                '''
            }
        }


        stage('Application Health Check') {

            steps {

                echo '=================================================='
                echo '          APPLICATION HEALTH CHECK'
                echo '=================================================='

                powershell '''

                    try {

                        $response = Invoke-WebRequest `
                            -UseBasicParsing `
                            -Uri "$env:TEST_URL/tasks" `
                            -TimeoutSec 10

                        Write-Host "Application HTTP Status:"
                        Write-Host $response.StatusCode


                        if ($response.StatusCode -ne 200) {

                            Write-Host "Application health check failed."

                            exit 1
                        }


                        Write-Host "Application health check successful."
                    }

                    catch {

                        Write-Host "Unable to access TaskNexus."

                        & "$env:DOCKER_EXE" logs $env:TEST_CONTAINER

                        exit 1
                    }
                '''
            }
        }


        stage('Application Content Check') {

            steps {

                echo '=================================================='
                echo '          APPLICATION CONTENT CHECK'
                echo '=================================================='

                powershell '''

                    try {

                        $response = Invoke-WebRequest `
                            -UseBasicParsing `
                            -Uri "$env:TEST_URL/tasks" `
                            -TimeoutSec 10

                        $content = $response.Content


                        if ([string]::IsNullOrWhiteSpace($content)) {

                            Write-Host "Application returned empty content."

                            exit 1
                        }


                        Write-Host "Application returned valid content."

                        Write-Host "Response length:"
                        Write-Host $content.Length
                    }

                    catch {

                        Write-Host "Content verification failed."

                        exit 1
                    }
                '''
            }
        }


        stage('Selenium Test Preparation') {

            steps {

                echo '=================================================='
                echo '          SELENIUM TEST PREPARATION'
                echo '=================================================='

                echo 'Selenium target URL:'
                echo '%TEST_URL%'

                bat 'dir src\\test'

                echo 'Selenium test preparation completed.'
            }
        }


        stage('Selenium Tests') {

            steps {

                echo '=================================================='
                echo '             SELENIUM TESTS'
                echo '=================================================='

                echo 'Running 10 Selenium automated test cases.'

                bat '''
                    mvn test ^
                    -Dheadless=true ^
                    -DbaseUrl=%TEST_URL%
                '''

                echo 'Selenium test execution completed.'
            }
        }


        stage('Test Result Verification') {

            steps {

                echo '=================================================='
                echo '          TEST RESULT VERIFICATION'
                echo '=================================================='

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


        stage('Publish JUnit Results') {

            steps {

                echo '=================================================='
                echo '            PUBLISH JUNIT RESULTS'
                echo '=================================================='

                junit(
                    testResults: 'target/surefire-reports/*.xml',
                    allowEmptyResults: false
                )

                echo 'JUnit results published.'
            }
        }


        stage('Archive Selenium Screenshots') {

            steps {

                echo '=================================================='
                echo '        ARCHIVE SELENIUM SCREENSHOTS'
                echo '=================================================='

                archiveArtifacts(
                    artifacts: 'target/selenium-screenshots/*.png',
                    allowEmptyArchive: true
                )

                echo 'Screenshot archive step completed.'
            }
        }


        stage('Final Container Check') {

            steps {

                echo '=================================================='
                echo '          FINAL CONTAINER CHECK'
                echo '=================================================='

                bat '"%DOCKER_EXE%" ps -a'

                echo 'Final container check completed.'
            }
        }


        stage('Final Image Check') {

            steps {

                echo '=================================================='
                echo '             FINAL IMAGE CHECK'
                echo '=================================================='

                bat '"%DOCKER_EXE%" images'

                echo 'Final Docker image check completed.'
            }
        }
    }


    post {


        success {

            echo ''
            echo '=================================================='
            echo '          TASKNEXUS PIPELINE SUCCESS'
            echo '=================================================='

            echo 'GitHub Checkout       : SUCCESS'
            echo 'Environment Check     : SUCCESS'
            echo 'Maven Clean           : SUCCESS'
            echo 'Maven Compile         : SUCCESS'
            echo 'Maven Test            : SUCCESS'
            echo 'WAR Packaging         : SUCCESS'
            echo 'WAR Verification      : SUCCESS'
            echo 'Docker Build          : SUCCESS'
            echo 'Docker Verification   : SUCCESS'
            echo 'Tomcat Deployment     : SUCCESS'
            echo 'Application Health    : SUCCESS'
            echo 'Selenium Tests        : SUCCESS'
            echo 'JUnit Results         : SUCCESS'

            echo '=================================================='
            echo '       TASKNEXUS CI/CD COMPLETED'
            echo '=================================================='
        }


        failure {

            echo ''
            echo '=================================================='
            echo '           TASKNEXUS PIPELINE FAILED'
            echo '=================================================='

            echo 'The failed stage should be checked in Console Output.'

            powershell '''

                $ErrorActionPreference = "SilentlyContinue"

                Write-Host "Docker containers:"

                & "$env:DOCKER_EXE" ps -a

                Write-Host "Docker logs:"

                & "$env:DOCKER_EXE" logs $env:TEST_CONTAINER

                exit 0
            '''
        }


        always {

            echo ''
            echo '=================================================='
            echo '              POST BUILD CLEANUP'
            echo '=================================================='


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

                Write-Host "Removing temporary Jenkins container..."

                & "$env:DOCKER_EXE" rm -f $env:TEST_CONTAINER

                Write-Host "Temporary container cleanup completed."

                exit 0
            '''


            echo '=================================================='
            echo '              CLEANUP COMPLETED'
            echo '=================================================='
        }
    }
    
}