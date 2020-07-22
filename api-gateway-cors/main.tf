resource "aws_api_gateway_method" "options" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.options.http_method
  type = "MOCK"
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
      "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
      "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [
      aws_api_gateway_integration.options_integration
  ]
}

resource "aws_api_gateway_method_response" "options_integration_method_response" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = true
      "method.response.header.Access-Control-Allow-Methods" = true
      "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# Access-Control-Allow-Headers 'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'
# Access-Control-Allow-Methods 'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'
# Access-Control-Allow-Origin '*'
