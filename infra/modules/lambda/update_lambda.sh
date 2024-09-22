#!/bin/bash

AWS_REGION="${AWS_REGION}"
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}"
ECR_REPO_NAME="${ECR_REPO_NAME}"
IMAGE_TAG="${IMAGE_TAG}"
LAMBDA_UPDATE="${LAMBDA_UPDATE}"

ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}"


aws lambda update-function-code --function-name $LAMBDA_UPDATE --image-uri ${ECR_REPO_URL}:${IMAGE_TAG} --region ${AWS_REGION}