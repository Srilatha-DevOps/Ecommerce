output "queue_id" {
  description = "ID of the created SQS queue"
  value       = aws_sqs_queue.my_queue.id
}

output "queue_arn" {
  description = "ARN of the created SQS queue"
  value       = aws_sqs_queue.my_queue.arn
}

output "queue_url" {
  value = aws_sqs_queue.my_queue.url
}

output "queue_name" {
  value = aws_sqs_queue.my_queue.name
}