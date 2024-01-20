pipeline {
    agent any

    environment {
        // Define environment variables
        GIT_REPO = 'https://github.com/rvsp/reactjs-demo'
        DOCKER_HUB_REPO = 'your-docker-hub-username/reactjs-demo'
        SERVER_USERNAME = 'your-server-username'
        SERVER_IP = 'your-server-ip'
        SERVER_DESTINATION = '/path/to/deploy'
    }

    post {
        success {
            emailext subject: "Build Success: \${JOB_NAME} \${BUILD_NUMBER}",
                      body: "Build successful. Check it out at ${BUILD_URL}",
                      to: 'your-email@example.com',
                      mimeType: 'text/html'
            }
        failure {
            emailext subject: "Build Failure: \${JOB_NAME} \${BUILD_NUMBER}",
                      body: "Build failed. Check the console output at ${BUILD_URL}",
                      to: 'your-email@example.com',
                      mimeType: 'text/html'
        }
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: env.GIT_REPO]]])
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def tag = "build-${BUILD_NUMBER}"
                    sh "./build.sh ${DOCKER_HUB_USERNAME} ${tag}"
                }
            }
        }


         stage('Update Docker Image Name') {
            steps {
                script {
                    def tag = "build-${BUILD_NUMBER}"
                    sh "sed -i 's|image: your-docker-hub-username/reactjs-demo:latest|image: ${DOCKER_HUB_REPO}:reactjs-demo:${tag}|' docker-compose.yml"
                }
            }
        
         }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials-id', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        sh "docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}"
                    }
                    def tag = "build-${BUILD_NUMBER}"
                    sh "docker push ${DOCKER_HUB_REPO}:${tag}"
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    sshagent(['your-ssh-credentials-id']) {
                        // Copy deploy.sh to the server
                        sh "scp -o StrictHostKeyChecking=no deploy.sh ${SERVER_USERNAME}@${SERVER_IP}:${SERVER_DESTINATION}"
                        
                        //copy docker-compose.yml to the server
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yml ${SERVER_USERNAME}@${SERVER_IP}:${SERVER_DESTINATION}"
                        
                        def tag = "build-${BUILD_NUMBER}"
                        // SSH into the server and execute deploy.sh
                        sh "ssh -o StrictHostKeyChecking=no ${SERVER_USERNAME}@${SERVER_IP} 'cd ${SERVER_DESTINATION} && ./deploy.sh ${DOCKER_HUB_USERNAME} ${DOCKER_HUB_PASSWORD} ${tag}'"
                    }
                }
            }
        }
    }
}
