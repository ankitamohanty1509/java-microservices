pipeline {
    agent any

    environment {
        SONAR_TOKEN = 'sqa_2052fb1a438726238b842acfdd509153ab8b51b0'
        SONAR_HOST_URL = 'http://localhost:9000'
        DOCKER_USER = 'ankitamohanty1509'
        DOCKER_PASS = credentials('docker-hub-credentials') 
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/ankitamohanty1509/java-microservices.git', branch: 'main'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "mvn sonar:sonar -Dsonar.projectKey=java-microservices -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_TOKEN"
                }
            }
        }

        stage('Docker Build & Push') {
    steps {
        withCredentials([usernamePassword(
            credentialsId: 'docker-hub-credentials', 
            usernameVariable: 'DOCKER_USER', 
            passwordVariable: 'DOCKER_PASS'
        )]) {
            sh '''
                echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                docker build -t ankitamohanty1509/my-app:latest .
                docker push ankitamohanty1509/my-app:latest
            '''
        }
    }
}


       stage('Deploy to Kubernetes') {
    steps {
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
            sh 'kubectl apply -f k8s/deployment.yaml --validate=false'
        }
    }
}
}
