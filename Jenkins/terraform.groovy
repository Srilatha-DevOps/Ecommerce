pipeline {
    agent any

    parameters {
        string(name: 'DOCKER_IMAGE_URI', description: 'Docker Image URI to deploy', defaultValue: '')
    }

    environment {
        AWS_DEFAULT_REGION = 'your_aws_region'
        TF_VAR_docker_image_uri = "${params.DOCKER_IMAGE_URI}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }

    post {
        always {
            stage('Terraform Clean Up') {
                steps {
                    script {
                        // Optionally, perform cleanup tasks after Terraform execution
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }
}
