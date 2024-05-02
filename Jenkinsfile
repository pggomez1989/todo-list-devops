pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                // Realiza cualquier paso de construcción necesario para tu aplicación
            }
        }
        stage('Start Containers') {
            steps {
                sh 'docker-compose up -d'
            }
        }
        stage('Test') {
            steps {
                // Ejecuta pruebas de integración o cualquier otro tipo de prueba necesario
            }
        }
        stage('Deploy') {
            steps {
                // Realiza cualquier paso necesario para desplegar tu aplicación
            }
        }
    }
}
