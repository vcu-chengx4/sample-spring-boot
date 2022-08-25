pipeline {
    agent none
        environment {
        ENV_DOCKER = credentials('dockerhub')
        DOCKERIMAGE = "dogistan/devopslab"
        EKS_CLUSTER_NAME = "hilarious-painting-1661434301"
        SONAR_TOKEN = credentials('sonar-token')
    }
    stages {
        stage('build') {
            agent {
                docker { image 'openjdk:11-jdk' }
            }
            steps {
                sh 'chmod +x gradlew && ./gradlew build jacocoTestReport'
                stash includes: 'build/**/*', name: 'build'
            }
        }
        stage('sonarqube') {
            agent {
                docker { image 'sonarsource/sonar-scanner-cli:latest' }
            }
            steps {
                unstash 'build'
                sh 'sonar-scanner'
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
            agent {
                docker {
                    image 'jshimko/kube-tools-aws:3.8.1'
                    args '-u root --privileged'
                }
            }
            steps {
                echo 'Deploying to kubernetes'

                withAWS(credentials:'aws-credentials') {
                    sh 'aws eks update-kubeconfig --name hilarious-painting-1661434301'
                    sh 'ls'
                    sh 'chmod +x deployment-status.sh && ./deployment-status.sh'
                    sh "kubectl set image deployment sample-spring-boot -n devopslab springboot-sample=$dogistan/devopslab:latest"
                }
            }
        }
    }
}
