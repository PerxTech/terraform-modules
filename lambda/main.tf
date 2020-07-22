data "archive_file" "api" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/tmp/${md5(var.source_dir)}.zip"
}

resource "aws_lambda_function" "api" {
  runtime          = var.runtime
  function_name    = var.function_name != "" ? var.function_name : basename(var.source_dir)
  handler          = var.handler
  role             = var.role_arn
  filename         = data.archive_file.api.output_path
  source_code_hash = data.archive_file.api.output_base64sha256
  memory_size      = var.memory_size

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = var.environment_variables
  }
}
