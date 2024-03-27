output "api_id" {
  description = "ID of the created API Gateway REST API"
  value       = aws_api_gateway_rest_api.my_api.arn
}
