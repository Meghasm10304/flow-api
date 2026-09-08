pipeline {
    agent any

    environment {
        APP_VERSION = "${env.BUILD_NUMBER}"
    }

    stages {

        stage('Setup Environment') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y git python3 python3-pip python3-venv
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv venv
                    ./venv/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    export PYTHONPATH=$WORKSPACE
                    ./venv/bin/pytest tests/ -v
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t flow-api:${BUILD_NUMBER} .'
            }
        }

        stage('Deploy Locally') {
            steps {
                sh '''
                    docker stop flow-api || true
                    docker rm flow-api || true
                    docker run -d -p 5000:5000 --name flow-api flow-api:${BUILD_NUMBER}
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    sleep 3
                    curl -f http://localhost:5000/health
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded — API deployed and healthy.'
        }

        failure {
            echo 'Pipeline failed — check logs above.'
        }
    }
}