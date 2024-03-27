output "role_arn" {
  description = ""
  value       = aws_iam_role.lambda_role.arn
}

output "ecs_task_execution_role" {
  value = aws_iam_role.task_execution_role.arn
}

output "ecs_task_role" {
  value = aws_iam_role.task_role.arn
}
