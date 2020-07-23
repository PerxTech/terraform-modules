data "aws_region" "current" {}

resource "aws_api_gateway_integration" "post_report_downloads" {
  rest_api_id             = var.rest_api_id
  resource_id             = var.resource_id
  http_method             = var.http_method
  type                    = "AWS_PROXY"
  credentials             = aws_iam_role.api_gateway_to_lambda.arn
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  integration_http_method = "POST"
  cache_key_parameters    = []
  timeout_milliseconds    = 29000
  content_handling        = "CONVERT_TO_TEXT"
  request_parameters = {
  }
}

resource "aws_iam_role" "api_gateway_to_lambda" {
  name_prefix = "api_gateway_to_lambda-${terraform.workspace}"

  assume_role_policy = <<-EOF
   {
    "Version":"2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal":{
            "Service": "apigateway.amazonaws.com"
          },
          "Effect":"Allow"
        }
      ] 
    }
  EOF
}

resource "aws_iam_role_policy" "api_gateway_to_lambda" {
  role        = aws_iam_role.api_gateway_to_lambda.name
  name_prefix = "execute_lambda"
  policy      = <<-EOF
    {
      "Version":"2012-10-17",
      "Statement": [
        {
          "Action": "lambda:InvokeFunction",
          "Resource":"${var.lambda_arn}",
          "Effect":"Allow"
        }
      ] 
    }
  EOF
}
