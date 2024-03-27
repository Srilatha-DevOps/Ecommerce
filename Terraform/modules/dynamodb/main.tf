resource "aws_dynamodb_table" "my_table" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.partition_key
  attribute {
    name = var.partition_key
    type = "N" 
  }
}