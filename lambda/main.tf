data "archive_file" "api" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/tmp/${md5(var.source_dir)}.zip"
}

locals {
  environments = var.environment_variables != null ? [var.environment_variables] : []
  name         = var.function_name != "" ? var.function_name : (length(basename(var.source_dir)) <= 32 ? basename(var.source_dir) : substr(replace(replace(replace(replace(replace(basename(var.source_dir), "u", ""), "o", ""), "i", ""), "e", ""), "a", ""), 0, 32))
}

resource "random_string" "suffix" {
  count   = var.use_unique_suffix ? 1 : 0
  length  = 4
  special = false
}

resource "aws_lambda_function" "api" {
  count            = var.enable ? 1 : 0
  runtime          = var.runtime
  function_name    = var.use_unique_suffix ? "${substr(local.name, 0, 28)}${random_string.suffix[0].result}" : local.name
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

resource "aws_iam_role_policy_attachment" "vpc" {
  count      = var.enable && length(var.subnet_ids) > 0 ? 1 : 0
  role       = aws_iam_role.role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  count = var.enable ? 1 : 0
  alarm_name = "${aws_lambda_function.api[0].function_name}-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 1
  threshold = 0
  treat_missing_data = "notBreaching"
  datapoints_to_alarm = 1
  dimensions = {
    "FunctionName" = aws_lambda_function.api[0].function_name
  }
  namespace = "AWS/Lambda"
  period = 300
  statistic = "Sum"
  ok_actions = []
  insufficient_data_actions = [] 
  alarm_actions = [
    var.alarm_sns_topic
  ]
  metric_name = "Errors"
  tags = var.tags
}