output "order_processor_arn" {
  description = ""
  value       = aws_lambda_function.order_processor.arn
}

output "email_name_arn" {
  description = ""
  value       = aws_lambda_function.email.arn
}


output "function_uri" {
  description = "URL of the created API Gateway REST API"
  value       = aws_lambda_function.order_processor.invoke_arn
}
