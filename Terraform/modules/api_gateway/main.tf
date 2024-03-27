resource "aws_api_gateway_rest_api" "my_api" {
  name        = var.api_name
  description = "My API Gateway REST API"
}

resource "aws_api_gateway_resource" "checkout" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "checkout"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.checkout.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "apigateway_invoke_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.checkout.id
  http_method = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type        = "AWS_PROXY"
  uri         = var.lambda_function_uri
}

resource "aws_api_gateway_deployment" "dev_deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = var.stage_name

  depends_on = [ aws_api_gateway_integration.lambda_integration ]
}


