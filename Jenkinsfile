pipeline {
    agent any

    triggers {
        pollSCM('*/2 * * * *')
    }


    stages {
        stage('Prepare Environment') {
            steps {
                sh '''
                cd ./Dockerfiles
                chmod +x shutdown.sh
                ./shutdown.sh
                '''
            }
        }
        stage('Build and Test') {
            steps {
                echo "Building and testing..."
                sh '''
                cd ./Dockerfiles
                docker compose build --no-cache
                docker compose up --exit-code-from test_app
                '''
            }
        }
        stage('Deploy') {
            steps {
                echo "Deploying ..."
                sh '''
                cd ./Dockerfiles
                docker build --no-cache -t jestapp:deploy -f Dockerfile.deploy .
                docker run -d -p 41247:3000 --name deploy-container jestapp:deploy
                '''
            }
        }
        stage('Archive') {
            steps {
                echo 'Archiving build output and test logs...'
                sh '''
                mkdir -p artifact 
		        cd ./artifact     
                docker logs build-container > build-logs.log
                docker logs test-container > test-logs.log
		        docker compose -f ./Dockerfiles/docker-compose.yaml down
                docker cp deploy-container:server/build .
                '''
                archiveArtifacts(artifacts: 'artifact/', onlyIfSuccessful: true)
            }
        }
    }
}