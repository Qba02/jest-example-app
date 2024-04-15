pipeline {
    agent any

    environment{
        DOCKERHUB_CREDENTIALS = credentials('qba002-dockerhub-token')
        IMAGE_NAME = 'jestapp'
    }

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
                docker compose build
                docker compose up --exit-code-from test_app
                '''
            }
        }
        stage('Deploy') {
            steps {
                echo "Deploying ..."
                sh '''
                cd ./Dockerfiles
                docker build -t $IMAGE_NAME:v1.${env.BUILD_NUMBER} -f Dockerfile.deploy .
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
		        docker compose -f ../Dockerfiles/docker-compose.yaml down
                docker cp deploy-container:server/build .
                cd ..
                tar -czf archive.tar.gz artifact/
                '''
                archiveArtifacts(artifacts: 'archive.tar.gz', onlyIfSuccessful: true)
            }
        }
        stage('Publish') {
            steps {
                echo "Publishing version number v1.${env.BUILD_NUMBER}"
                sh '''
                docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                docker tag $IMAGE_NAME:v1.${env.BUILD_NUMBER} qba002/$IMAGE_NAME:v1.${env.BUILD_NUMBER}
                docker tag $IMAGE_NAME:v1.${env.BUILD_NUMBER} qba002/$IMAGE_NAME:latest
                docker push qba002/$IMAGE_NAME:v1.${env.BUILD_NUMBER}
                docker push qba002/$IMAGE_NAME:latest
                docker rmi qba002/$IMAGE_NAME:latest qba002/$IMAGE_NAME:v1.${env.BUILD_NUMBER}
                '''
            }
        }
    }
    post{
        always{
            sh 'docker logout'
        }
    }
}