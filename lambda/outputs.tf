output "arn" {
  value = length(aws_lambda_function.api) > 0 ? aws_lambda_function.api[0].arn : null
}

output "name" {
  value = length(aws_lambda_function.api) > 0 ? aws_lambda_function.api[0].function_name : null
}

output "role_name" {
  value = length(aws_iam_role.role) > 0 ? aws_iam_role.role[0].name : null
}

output "role_id" {
  value = length(aws_iam_role.role) > 0 ? aws_iam_role.role[0].id : null
}
