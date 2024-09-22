output "lambda_function_arn" {
  description = "ARN da função Lambda criada"
  value       = aws_lambda_function.lambda_function.arn
}

output "lambda_role_arn" {
  description = "ARN da role da Lambda"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_function_name" {
  description = "Nome da função Lambda criada"
  value       = aws_lambda_function.lambda_function.function_name
}

