pipeline {
    agent any
    environment {
        APP_VERSION = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') { steps { checkout scm } }
        stage('Install') { steps { sh 'pip install -r requirements.txt' } }
        stage('Test') { steps { sh 'pytest tests/ -v' } }
        stage('Build') { steps { sh 'docker build -t flow-api:${BUILD_NUMBER} .' } }
        stage('Deploy') {
            steps {
                sh 'docker stop flow-api || true'
                sh 'docker rm flow-api || true'
                sh 'docker run -d -p 5000:5000 --name flow-api flow-api:${BUILD_NUMBER}'
            }
        }
        stage('Verify') { steps { sh 'sleep 3 && curl -f http://localhost:5000/health' } }
    }
}
