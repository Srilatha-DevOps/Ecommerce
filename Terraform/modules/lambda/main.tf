data "archive_file" "order_processor" {
  type        = "zip"
  source_file = "${path.module}/src/python/lambda_function.py"
  output_path = "orderprocessor_function.zip"
}

data "archive_file" "email" {
  type        = "zip"
  source_file = "${path.module}/src/python/email.py"
  output_path = "email.zip"
}

resource "aws_lambda_function" "order_processor" {
  function_name    = var.order_processor_name
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  role             = var.role_arn

  filename = "orderprocessor_function.zip"
  source_code_hash = data.archive_file.order_processor.output_base64sha256

  environment {
    variables = {
      environment_varible = var.environment_variable
    }
  }
}

resource "aws_lambda_function" "email" {
  function_name    = var.email_name
  handler          = "email.lambda_handler"
  runtime          = "python3.9"
  role             = var.role_arn

  filename = "email.zip"
  source_code_hash = data.archive_file.email.output_base64sha256

  environment {
    variables = {
      environment_varible = var.environment_variable
    }
  }
}

resource "aws_lambda_permission" "lambda_ses_permission" {
  statement_id  = "AllowSES"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email.function_name
  principal     = "ses.amazonaws.com"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  
  bucket = var.s3_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.email.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}