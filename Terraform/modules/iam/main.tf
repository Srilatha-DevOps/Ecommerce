resource "aws_iam_role" "lambda_role" {
  name = var.sqs_role_name
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "lambda_full_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_role_policy_attachment" "execute_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Define the IAM policy allowing Lambda to send messages to SQS
resource "aws_iam_policy" "lambda_sqs_policy" {
  name        = "lambda-sqs-policy"
  description = "Allows Lambda to send messages to SQS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = [
        "sqs:SendMessage",
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl"
      ],
      Resource  = var.sqs_queue_arn  # Update with your SQS queue ARN
    }]
  })
}

# Attach the SQS policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_sqs_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_sqs_policy.arn

}


resource "aws_iam_role" "task_execution_role" {
  name               = var.task_execution_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "s3_ecr_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name               = var.task_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "s3_dynamodb_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
  }
  statement {
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem"]
    resources = [var.dynamo_db_table_arn]
  }
  statement {
    actions   = ["sqs:ReceiveMessage", "sqs:GetQueueUrl","sqs:GetQueueAttributes","sqs:DeleteMessage"]
    resources = [var.sqs_queue_arn]
  }
}

resource "aws_iam_policy" "ecs_s3_dynamodb_policy" {
  name        = "ecommerce-task-s3-dynamodb-access-policy"
  policy = data.aws_iam_policy_document.s3_dynamodb_policy.json
}

# Attach IAM Policy to Task Execution Role
resource "aws_iam_role_policy_attachment" "s3_dynamodb_attachment" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.ecs_s3_dynamodb_policy.arn
}