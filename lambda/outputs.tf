output "arn" {
  value = var.enable ? aws_lambda_function.api[0].arn : null
}

output "name" {
  value = var.enable ? aws_lambda_function.api[0].function_name : null
}

output "role_name" {
  value = var.enable ? aws_iam_role.role[0].name : null
}

output "role_id" {
  value = var.enable ? aws_iam_role.role[0].id : null
}
