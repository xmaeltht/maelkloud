pipeline {
    agent any
    environment {
        DOCKERHUB_USERNAME = '<DOCKER_HUB_USERNAME>'
        DOCKERHUB_PASSWORD = '<DOCKER_HUB_PASSWORD>'
        IMAGE_NAME = 'xmaeltht/dockertestpipeline'
        GIT_REPO = 'https://github.com/xmaeltht/maelkloud.git'
    }
    stages {
        stage('Checkout Repository') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']], // Replace 'main' with the branch name you want to checkout
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[url: "${GIT_REPO}"]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_credentials') {
                        def customImage = docker.build("${IMAGE_NAME}:${env.BUILD_NUMBER}", "--file 2-docker-intro/Dockerfile .")
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_credentials') {
                        def customImage = docker.image("${IMAGE_NAME}:${env.BUILD_NUMBER}")
                        customImage.push()
                        customImage.push('latest')
                    }
                }
            }
        }
    }
}
