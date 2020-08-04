data "archive_file" "api" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/tmp/${md5(var.source_dir)}.zip"
}

locals {
  environments = var.environment_variables != null ? [var.environment_variables] : []
  name         = var.function_name != "" ? var.function_name : (length(basename(var.source_dir)) <= 32 ? basename(var.source_dir) : substr(replace(replace(replace(replace(replace(basename(var.source_dir), "u", ""), "o", ""), "i", ""), "e", ""), "a", ""), 0, 32))
}

resource "aws_lambda_function" "api" {
  count            = var.enable ? 1 : 0
  runtime          = var.runtime
  function_name    = local.name
  handler          = var.handler
  role             = aws_iam_role.role[0].arn
  filename         = data.archive_file.api.output_path
  source_code_hash = data.archive_file.api.output_base64sha256
  memory_size      = var.memory_size
  timeout          = var.timeout

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  dynamic "environment" {
    for_each = local.environments

    content {
      //todo
      variables = environment.value
    }
  }
  tags = var.tags

  depends_on = [aws_iam_role_policy_attachment.basic[0]]
}

resource "aws_iam_role" "role" {
  count              = var.enable ? 1 : 0
  name_prefix        = local.name
  assume_role_policy = <<-EOF
  {
    "Version":"2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal":{
            "Service": "lambda.amazonaws.com"
          },
          "Effect":"Allow"
        }
      ] 
    }
  EOF

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "basic" {
  count      = var.enable ? 1 : 0
  role       = aws_iam_role.role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
