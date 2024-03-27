pipeline {
    agent any
    
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'  // Update with your AWS region
        AWS_ACCOUNT_ID = 'your_aws_account_id'
        ECR_REPO_URI = 'your_ecr_repository_name'
        DOCKERFILE_PATH = 'path_to_your_dockerfile/Dockerfile'
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build('${ECR_REPO_URI}/image_name:tag')
                }
            }
        }
        
        stage('Push Docker Image to ECR') {
            steps {
                script {
                    withAWS(credentials: 'aws_credentials_id', region: AWS_DEFAULT_REGION) {
                        docker.withRegistry('https://${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com', 'ecr:us-east-1') {
                            docker.image('your_ecr_registry_uri/image_name:tag').push('latest')
                        }
                    }
                }
            }
        }
        
        stage('Trigger Terraform Pipeline') {
            steps {
                script {
                    def dockerImageURI = "https://${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO_NAME}:latest"
                    build job: 'terraform_pipeline', parameters: [string(name: 'DOCKER_IMAGE_URI', value: dockerImageURI)]
                }
            }
        }
    }
}
