pipeline {
    agent any

    triggers {
        pollSCM('*/2 * * * *')
    }

    stages {
        stage('BuildAndTest') {
            steps {
                echo "Building and testing..."
                sh '''
                cd ./Dockerfiles
                docker compose up --exit-code-from test_app
                '''
            }
        }
        stage('Deliver') {
            steps {
                echo 'Deliver...'
                sh '''
		cd ./Dockerfiles       
                docker logs build-container > build-logs.log
                docker logs test-container > test-logs.log
		docker compose down
                '''
            }
        }
    }
}