pipeline {
    agent any

    environment {
        APP_VERSION = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Setup Environment') {
            steps {
                // Install Git and Python
                sh '''
                    apt-get update
                    apt-get install -y git python3 python3-pip
                '''
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
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