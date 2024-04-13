pipeline {
    agent any

    triggers {
        pollSCM('*/2 * * * *')
    }


    stages {
        stage('PrepareEnvironment') {
            steps {
                echo "Stopping and removing previous containers..."
                sh '''
                docker stop -f $(docker ps -a -q)
                docker rm -f $(docker ps -a -q)
                '''
            }
        }
        stage('BuildAndTest') {
            steps {
                echo "Building and testing..."
                sh '''
                cd ./Dockerfiles
                docker compose up --exit-code-from test_app
                '''
            }
        }
        stage('Deploy') {
            steps {
                echo "Deploying ..."
                sh '''
                cd ./Dockerfiles
                docker build -t jestapp:deploy -f Dockerfile.deploy .
                docker run -d -p:41247:3000 --name deploy-container jestapp:deploy
                '''
            }
        }
        stage('Archive logs') {
            steps {
                echo 'Archiving logs...'
                sh '''
		        cd ./Dockerfiles       
                docker logs build-container > build-logs.log
                docker logs test-container > test-logs.log
                docker logs deploy-container > deploy-logs.log
		        docker compose down
                '''
            }
        }
    }
}