pipeline {
    agent any

    environment {
        IMAGE_NAME = "anshu9103/capstone-website"
        IMAGE_TAG = "v1"
        K8S_MASTER = "ubuntu@3.111.33.219"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker buildx build --platform linux/amd64 -t $IMAGE_NAME:$IMAGE_TAG ./docker --load'
            }
        }

        stage('Docker Push') {
            steps {
                sh 'docker push $IMAGE_NAME:$IMAGE_TAG'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'scp kubernetes/deployment.yml kubernetes/service.yml $K8S_MASTER:~'
                sh 'ssh $K8S_MASTER "kubectl apply -f deployment.yml && kubectl apply -f service.yml"'
                sh 'ssh $K8S_MASTER "kubectl rollout restart deployment website-deployment"'
                sh 'ssh $K8S_MASTER "kubectl get pods && kubectl get svc"'
            }
        }
    }
}