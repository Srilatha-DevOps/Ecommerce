terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.42.0"
    }
  }

  backend "s3" {
    bucket = "ecommerce-s3-backend"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

data "aws_security_group" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]  # Update with your VPC ID
  }
}


#Calling vpc
module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr_block        = var.vpc_cidr_block
  subnet_cidr_blocks    = var.subnet_cidr_blocks
  security_group    = data.aws_security_group.default.id
}

#Calling SQS module

module "my_sqs_queue" {
  source = "./modules/sqs"
  queue_name = var.queue_name
}


#calling S3 module

module "my_s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

# #Calling dynamodb module

module "my_dynamodb_table" {
  source        = "./modules/dynamodb"
  table_name    = var.table_name
  partition_key = var.partition_key
}

#Calling 
module "iam" {
  source               = "./modules/iam"
  sqs_role_name        = var.sqs_role_name
  sqs_queue_arn        = module.my_sqs_queue.queue_arn
  bucket_name          = var.bucket_name
  dynamo_db_table_arn = module.my_dynamodb_table.dynamo_db_table_arn
  task_execution_role_name = var.task_execution_role_name
  task_role_name       = var.task_role_name
}

# Call the lambda_function to order_processing
module "lambda" {
  source            = "./modules/lambda"
  order_processor_name     = var.lambda_function.order_processing.name
  email_name        = var.lambda_function.invoice_generator.name
  security_group    = data.aws_security_group.default.id
  role_arn          = module.iam.role_arn
  environment_variable = var.lambda_function.order_processing.environment_variable
  s3_bucket_arn = module.my_s3_bucket.s3_bucket_arn
  s3_bucket_id = module.my_s3_bucket.s3_bucket_id
}


# Call the api_gateway module
module "my_api_gateway" {
  source      = "./modules/api_gateway"
  api_name    = var.api_name
  stage_name  = var.stage_name
  lambda_function_name = var.lambda_function.order_processing.name
  lambda_function_uri = module.lambda.function_uri
  lambda_function_arn = module.lambda.order_processor_arn
}

#call ECS
module "ecommerce_ecs" {
  source      = "./modules/ecs"
  ecs-cluster-name = var.ecs-cluster-name
  service_name = var.service_name
  task-definition-name = var.task-definition-name
  image_uri = var.image_uri
  ecs_task_execution_role = module.iam.ecs_task_execution_role
  ecs_task_role = module.iam.ecs_task_role
  subnet_id     = [module.vpc.lambda_subnet_id, module.vpc.ecs_subnet_id]
  security_group_id = data.aws_security_group.default.id
  s3_bucket_name = var.bucket_name
  dynamodb_table_name = var.table_name
  sqs_url = module.my_sqs_queue.queue_url
}





