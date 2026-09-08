pipeline {
    agent any

    environment {
        APP_VERSION = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Python & Dependencies') {
            steps {
                // Install Python and pip if not present
                sh 'apt-get update && apt-get install -y python3 python3-pip'
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'pytest tests/ -v'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build using the host Docker socket
                sh 'docker build -t flow-api:${BUILD_NUMBER} .'
            }
        }

        stage('Deploy Locally') {
            steps {
                sh 'docker stop flow-api || true'
                sh 'docker rm flow-api || true'
                sh 'docker run -d -p 5000:5000 --name flow-api flow-api:${BUILD_NUMBER}'
            }
        }

        stage('Health Check') {
            steps {
                sh 'sleep 3 && curl -f http://localhost:5000/health'
            }
        }
    }

    post {
        success { echo 'Pipeline succeeded — API deployed and healthy.' }
        failure { echo 'Pipeline failed — check logs above.' }
    }
}