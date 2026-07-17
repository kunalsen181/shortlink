pipeline {
    agent any

    environment {
        KIND_CLUSTER = "shortlink-cluster"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Backend Image') {
            steps {
                sh 'docker build -t shortlink-backend:latest ./backend'
            }
        }

        stage('Build Frontend Image') {
            steps {
                sh 'docker build -t shortlink-frontend:latest ./frontend'
            }
        }

        stage('Load Images into Kind') {
            steps {
                sh 'kind load docker-image shortlink-backend:latest --name $KIND_CLUSTER'
                sh 'kind load docker-image shortlink-frontend:latest --name $KIND_CLUSTER'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f K8s/db.yaml -f K8s/cache.yaml -f K8s/backend.yaml -f K8s/frontend.yaml -f K8s/ingress.yaml'
                sh 'kubectl rollout restart deployment backend'
                sh 'kubectl rollout restart deployment frontend'
            }
        }
    }
}
