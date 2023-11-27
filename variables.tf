# Variable for AWS Region
variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
}

# ECR Repository
variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

# Lambda Function
variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "image_uri" {
  description = "URI of the Docker image for the Lambda function"
  type        = string
}

# S3 Bucket
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

# IAM Role for Lambda
variable "lambda_iam_role_name" {
  description = "Name of the IAM role for Lambda"
  type        = string
}

# EventBridge Rule
variable "eventbridge_rule_name" {
  description = "Name of the EventBridge rule"
  type        = string
}

variable "eventbridge_schedule_expression" {
  description = "Schedule expression for the EventBridge rule"
  type        = string
}
