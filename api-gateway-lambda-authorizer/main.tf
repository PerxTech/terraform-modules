data "aws_region" "current" {}

# arn:aws:apigateway:us-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-2:012345678912:function:my-function/invocations
resource "aws_api_gateway_authorizer" "authorizer" {
  name                             = "admin-auth"
  rest_api_id                      = var.rest_api_id
  authorizer_uri                   = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  authorizer_credentials           = aws_iam_role.authorizer_invoke.arn
  authorizer_result_ttl_in_seconds = 0
}

resource "aws_iam_role" "authorizer_invoke" {
  name_prefix        = "authorizer-invoke-${terraform.workspace}"
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

  tags = var.tags
}

resource "aws_iam_role_policy" "authorizer_invoke" {
  name_prefix = "invoke_lambda"
  role        = aws_iam_role.authorizer_invoke.id
  policy      = <<-EOF
    {
      "Version":"2012-10-17",
      "Statement": [
        {
          "Action": ["lambda:InvokeFunction"],
          "Resource":"${var.lambda_arn}",
          "Effect":"Allow"
        }
      ]
    }
  EOF
}
