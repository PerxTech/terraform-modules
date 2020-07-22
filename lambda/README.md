```tf
resource "aws_iam_role" "sample" {
  name_prefix = "for_sample_lambda"

  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow"
        }
      ]
    }
  EOF
}

module "sample" {
  source = "git@github.com:PerxTech/terraform-modules.git//lambda"
  source_dir = "${path.module}/../dist/apps/sample"
  role_arn = aws_iam_role.sample.arn
}
```
