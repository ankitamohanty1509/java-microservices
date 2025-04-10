pipeline {
    agent any

    environment {
        SONAR_TOKEN = 'sqa_2052fb1a438726238b842acfdd509153ab8b51b0'
        SONAR_HOST_URL = 'http://localhost:9000'
        DOCKER_IMAGE = 'ankitamohanty1509/java-app:latest'
        DOCKER_USERNAME = 'ankitamohanty1509' // change if needed
        DOCKER_PASSWORD = credentials('dockerhub-password') // store this in Jenkins Credentials
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                sh """
                    mvn sonar:sonar \
                        -Dsonar.projectKey=java-microservices \
                        -Dsonar.projectName="Java Microservices" \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.host.url=${SONAR_HOST_URL} \
                        -Dsonar.login=${SONAR_TOKEN}
                """
            }
        }

        stage('Docker Build & Push') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
                sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
                sh 'kubectl get pods'
            }
        }
    }
}
