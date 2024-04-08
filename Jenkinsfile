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
                docker-compose up --exit-code-from test_app
                docker compose down
                '''
            }
        }
        stage('Deliver') {
            steps {
                echo 'Deliver...'
                sh '''       
		mkdir logs         
                docker compose logs build_app > logs/build-logs.txt
                docker compose logs test_app > logs/test-logs.txt
                '''
            }
        }
    }
}