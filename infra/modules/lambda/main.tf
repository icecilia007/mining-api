# IAM Policy Document for Lambda Role
data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_role" {
  name               = "${var.function_name}_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
}

# Attach Basic Lambda Execution Role
resource "aws_iam_role_policy_attachment" "lambda_exec_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach Additional IAM Policies (if any)
resource "aws_iam_role_policy_attachment" "lambda_custom_policy" {
  count      = length(var.additional_policies)
  role       = aws_iam_role.lambda_role.name
  policy_arn = element(var.additional_policies, count.index)
}

# Docker image repository
resource "aws_ecr_repository" "lambda_docker" {
  name                 = lower("${var.env}-${var.project}-${var.function_name}")
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Manager off imagens off the repository
resource "aws_ecr_lifecycle_policy" "delete_images_lambda_iceberg" {
  repository = aws_ecr_repository.lambda_docker.name
  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep only the most recent image",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

# Lambda Function
resource "aws_lambda_function" "lambda_function" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  memory_size   = 128
  image_uri     = "${aws_ecr_repository.lambda_docker.repository_url}:latest"
  timeout       = 900
  depends_on = [aws_ecr_repository.lambda_docker]
}

# Lambda Function Event Configuration (Optional)
resource "aws_lambda_function_event_invoke_config" "lambda_invoke_config" {
  function_name                = aws_lambda_function.lambda_function.function_name
  maximum_event_age_in_seconds = var.max_event_age_in_seconds
  maximum_retry_attempts       = var.max_retry_attempts
}

resource "null_resource" "build_and_push_ecr_lambda" {
  triggers = {
    python_files_hash = filesha256("${path.module}/../../scripts")
    docker_files_hash = filesha256("${path.module}/../../Dockerfile")
  }

  provisioner "local-exec" {
    command = "chmod +x ./${path.module}/build_and_push_ecr.sh && ./${path.module}/build_and_push_ecr.sh"
    environment = {
      FOLDER         = "lambda/"
      AWS_REGION     = var.aws_region
      AWS_ACCOUNT_ID = local.aws_account_id
      ECR_REPO_NAME  = aws_ecr_repository.lambda_exemplo.name
      IMAGE_TAG      = "latest"
    }
    interpreter = ["/bin/bash", "-c"]
  }
  depends_on = [aws_ecr_repository.lambda_exemplo]
}


resource "null_resource" "update_lambda" {
  triggers = {
    python_files_hash = filesha256("../scripts/ecr/lambda/main.py")
    docker_files_hash = filesha256("../scripts/ecr/lambda/Dockerfile")
  }

  provisioner "local-exec" {
    command = "chmod +x ./${path.module}/update_lambda.sh && ./${path.module}/update_lambda.sh"
    environment = {
      AWS_REGION     = var.aws_region
      AWS_ACCOUNT_ID = local.aws_account_id
      ECR_REPO_NAME  = aws_ecr_repository.lambda_exemplo.name
      IMAGE_TAG      = "latest"
      LAMBDA_UPDATE  = module.lambda_1.name
    }
    interpreter = ["/bin/bash", "-c"]
  }
  depends_on = [module.lambda_1]
}
