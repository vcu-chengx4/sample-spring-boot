pipeline {
    agent none
        environment {
        ENV_DOCKER = credentials('dockerhub')
        DOCKERIMAGE = "dogistan/devopslab"
        EKS_CLUSTER_NAME = "demo-cluster"
        SONAR_TOKEN = "921b2089dd06be27e8e346ada6e90b1f021a5ca6"
    }
    stages {
        stage('build') {
            agent {
                docker { image 'openjdk:11-jdk' }
            }
            steps {
                sh 'chmod +x gradlew && ./gradlew build jacocoTestReport'
            }
        }
        stage('sonarqube') {
        agent {
            docker { image 'sonarsource/sonar-scanner-cli:latest' } }
            steps {
                sh 'echo scanning!'
            }
        }
        stage('docker build') {
            steps {
                script {
                    echo "building image"
                    dockerImage = docker.build("dogistan/devopslab:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('docker push') {
            steps {
                script {
                    echo "uploading image"
                    docker.withRegistry('https://registry.hub.docker.com/','dockerhub') {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('Deploy App') {
            steps {
                sh 'echo deploy to kubernetes'               
            }
        }
    }
}
