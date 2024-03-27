output "dynamo_db_table_name" {
  value = aws_dynamodb_table.my_table.name
}

output "dynamo_db_table_arn" {
  value = aws_dynamodb_table.my_table.arn
}