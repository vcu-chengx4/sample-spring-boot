pipeline {
    agent none
        environment {
        ENV_DOCKER = credentials('dockerhub')
        DOCKERIMAGE = "dogistan/devopslab"
        EKS_CLUSTER_NAME = "demo-cluster"
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
                    docker.withRegistry('https://registry.hub.docker.com/','Docker') {
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
