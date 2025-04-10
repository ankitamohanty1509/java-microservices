pipeline {
    agent any

    environment {
        SONAR_TOKEN = 'sqa_2052fb1a438726238b842acfdd509153ab8b51b0'
        SONAR_HOST_URL = 'http://localhost:9000'
        DOCKER_IMAGE = 'ankitamohanty1509/java-app:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/ankitamohanty1509/java-microservices.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        docker build -t $DOCKER_IMAGE .
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                '''
            }
        }
    }
}
