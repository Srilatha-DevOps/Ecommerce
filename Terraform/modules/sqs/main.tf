resource "aws_sqs_queue" "my_queue" {
  name = var.queue_name
}
