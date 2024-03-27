variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}


##Variables for SQS

variable "queue_name" {
  description = "Name of the SQS queue"
}

##Variable for VPC
variable "vpc_cidr_block" {
  description = "Name of the API Gateway REST API"
}

variable "subnet_cidr_blocks" {
  description = "Name of the API Gateway REST API"
  type        = list(string)
}

##Iam

variable "sqs_role_name" {
  description = ""
}

# Lambda 
variable "lambda_function" {
  type = map(object({
    name                 = string
    environment_variable = string
  }))
}

# variable "sqs_queue_url" {
#   description = "URL of the SQS queue"
# }

##APIGateway

variable "api_name" {
  description = "Name of the API Gateway REST API"
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
}

variable "task_execution_role_name" {
  description = ""
}
variable "task_role_name" {
  
}

##variables for S3
variable "bucket_name" {
  description = "S3 bucket"
}

##Variables for Dynamodb
variable "table_name" {
  description = "dynamodb table"
}

variable "partition_key" {
  description = "partition key"
}

variable "ecs-cluster-name" {
  
}

variable "task-definition-name" {
  
}

variable "image_uri" {
  
}

variable "service_name" {
  
}

variable "ecr_repo_name" {
  
}

# variable "security_group_ingress_cidr_blocks" {
#   description = "List of CIDR blocks for security group ingress"
#   type        = list(string)
# }


