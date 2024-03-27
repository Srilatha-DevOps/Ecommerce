aws_region = "us-east-1"
queue_name = "ecommerce-queue-01"
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_blocks = ["10.0.1.0/24","10.0.2.0/24"]
sqs_role_name = "ecommerce-lambda-sqsl-role-01"
api_name = "ecommerge-api-gateway-01"
stage_name = "dev"
task_execution_role_name = "ecommerce-ecs-task-execution-role-01"
task_role_name = "ecommerce-ecs-task-role-01"
bucket_name = "ecommerce-bucket-01"
table_name = "ecommerce-dynamodb-01"
partition_key = "id"
ecs-cluster-name = "ecommerce-cluster-01"
task-definition-name = "ecommerce-taskdefition-01"
image_uri = "471112581276.dkr.ecr.us-east-1.amazonaws.com/ecommerce-repo:latest"
service_name = "ecommerce-service-01"
ecr_repo_name = "ecommerce-repo"


lambda_function = {
  order_processing = {
    name          = "ecommerce-order-processing-lambda-01"
    environment_variable = "ecommerce-queue-01"
  }
  invoice_generator = {
    name          = "ecommerce-notification-lambda-01"
    environment_variable = ""
  }
}