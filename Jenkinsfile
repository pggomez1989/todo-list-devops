pipeline {
    agent any
    environment {
        GIT_REPOSITORY = "git@github.com:pggomez1989/todo-list-devops.git"
        BRANCH_PROJECT = "main"
    }
    stages {
        stage('Build start') {
            steps {
                git 'https://github.com/pggomez1989/todo-list-devops.git'
            },
            steps {
                git branch: "${BRANCH_PROJECT}",
                    // credentialsId: 'ae4f69cd-46dc-4031-8750-4b9dcaa005ed',
                    credentialsId: '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',
                    url: "${GIT_REPOSITORY}"
            }
        }
        stage('Setup Terraform') {
            steps {
                sh 'terraform init'
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
    parameters {
        booleanParam(name: 'DESTROY_INFRA', defaultValue: false, description: 'Set to true to destroy the infrastructure')
    }
}
