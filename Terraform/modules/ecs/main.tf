resource "aws_ecs_cluster" "ecommerce_cluster" {
  name = var.ecs-cluster-name
}

resource "aws_ecs_task_definition" "ecommerce_task_definition" {
  family                   = var.task-definition-name
  execution_role_arn       = var.ecs_task_execution_role
  task_role_arn            = var.ecs_task_role
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048


  container_definitions = <<EOF
[
  {
    "name": "my-container",
    "image": "${var.image_uri}",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "environment": [
      {
        "name": "S3_BUCKET", 
        "value": "${var.s3_bucket_name}"
      },
      {
        "name": "DYNAMODB_TABLE", 
        "value": "${var.dynamodb_table_name}"
      },
      {
        "name": "SQS_QRL", 
        "value": "${var.sqs_url}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "ecommerce-loggroup",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "ecommerce_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.ecommerce_cluster.id
  task_definition = aws_ecs_task_definition.ecommerce_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    subnets          = var.subnet_id
    security_groups  = [var.security_group_id]
  }

  depends_on = [aws_ecs_task_definition.ecommerce_task_definition]
}

# Define Autoscaling Policy
# resource "aws_appautoscaling_policy" "my_scaling_policy" {
#   name               = "my-scaling-policy"
#   service_namespace  = "ecs"
#   resource_id        = "service/${aws_ecs_cluster.my_cluster.name}/${aws_ecs_service.my_service.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   policy_type        = "TargetTrackingScaling"

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }
#     target_value            = 50.0
#     scale_in_cooldown       = 60
#     scale_out_cooldown      = 60
#   }
# }