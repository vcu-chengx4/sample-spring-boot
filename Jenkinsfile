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
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'hilarious-painting-1661434301', contextName: 'arn:aws:eks:us-east-1:828621778012:cluster/hilarious-painting-1661434301', credentialsId: 'K8S', namespace: '', serverUrl: 'https://B6231C79817C55F8EC58BBB3E1409890.gr7.us-east-1.eks.amazonaws.com') {
                    sh ('kubectl get all')
                }      
            }
        }
    }
}
