pipeline {
    agent any

    environment {
        IMAGE_NAME = "anshu9103/capstone-website"
        IMAGE_TAG = "${BUILD_NUMBER}"
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
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG ./docker'
            }
        }

        stage('Docker Push') {
            steps {
                sh 'docker push $IMAGE_NAME:$IMAGE_TAG'
            }
        }
stage('Deploy to Kubernetes') {
    steps {
        sh 'scp kubernetes/service.yml ubuntu@3.111.33.219:~'
        sh 'ssh $K8S_MASTER "kubectl apply -f service.yml"'
        sh 'ssh $K8S_MASTER "kubectl set image deployment/website-deployment website-container=$IMAGE_NAME:$IMAGE_TAG"'
        sh 'ssh $K8S_MASTER "kubectl rollout status deployment/website-deployment"'
        sh 'ssh $K8S_MASTER "kubectl get pods && kubectl get svc"'
    }
}
    }$
}