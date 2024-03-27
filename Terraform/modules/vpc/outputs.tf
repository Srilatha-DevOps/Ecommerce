output "vpc_id" {
  description = "ID of the created API Gateway REST API"
  value       = aws_vpc.main_vpc.id
}

output "lambda_subnet_id" {
  description = "Use this to get the lambda subnet id"
  value       = tolist(aws_subnet.subnets)[0].id
}

output "ecs_subnet_id" {
  description = "Use this to get the lambda subnet id"
  value       = tolist(aws_subnet.subnets)[1].id
}