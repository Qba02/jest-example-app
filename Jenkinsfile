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
                docker compose down
                '''
            }
        }
        stage('Deliver') {
            steps {
                echo 'Deliver...'
                sh '''
		cd ./Dockerfiles       
                docker compose logs build_app > build-logs.txt
                docker compose logs test_app > test-logs.txt
                '''
            }
        }
    }
}