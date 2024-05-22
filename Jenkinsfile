pipeline {
    agent any
    environment {
        GIT_REPOSITORY = "git@github.com:pggomez1989/todo-list-devops.git"
        BRANCH_PROJECT = "main"
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key') 
    }
    parameters {
        booleanParam(name: 'DESTROY_INFRA', defaultValue: false, description: 'Set to true to destroy the infrastructure')
    }
    stages {
        // stage('Build start') {
        //     steps {
        //         git branch: "${BRANCH_PROJECT}",
        //             credentialsId: '7df94e06-bbc2-4332-83e5-dfac02b22fd6',
        //             url: "${GIT_REPOSITORY}"
        //     }
        // }
        stage('Setup Terraform') {
            steps {
                script {
                    // Verifica la versión de Terraform
                    sh 'terraform --version'
                    
                    // Inicializa Terraform
                    def tfInitStatus = sh(script: 'terraform init', returnStatus: true)
                    
                    // Verifica el resultado de la inicialización de Terraform
                    if (tfInitStatus == 0) {
                        echo 'Terraform initialized successfully.'
                    } else {
                        error 'Failed to initialize Terraform.'
                    }
                }
            }
        }
        stage('Apply Terraform') {
            when {
                expression { return !params.DESTROY_INFRA }
            }
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Destroy Terraform') {
            when {
                expression { return params.DESTROY_INFRA }
            }
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
        stage('Deploy Docker Compose') {
            when {
                expression { return !params.DESTROY_INFRA }
            }
            steps {
                script {
                    def instance_ip = sh(script: 'terraform output -raw instance_ip', returnStdout: true).trim()
                    sh "scp -o StrictHostKeyChecking=no -i ~/.ssh/my-key-api.pem docker-compose.yml ubuntu@${instance_ip}:/home/ubuntu/"
                    sh "ssh -o StrictHostKeyChecking=no -i ~/.ssh/my-key-api.pem ubuntu@${instance_ip} 'docker-compose -f /home/ubuntu/docker-compose.yml up -d'"
                }
            }
        }
    }
}
