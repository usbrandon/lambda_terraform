# AWS Region
aws_region = "us-east-1"

# ECR Repository Name (only lowercase names allowed)
ecr_repository_name = "lambdatest"

# Lambda Function Name and Image URI
# Note: The image_uri should be updated with the actual Docker image URI after it is built and pushed to ECR.
lambda_function_name = "lambdaTest"

# S3 Bucket Name
# Note: This is assumed from the context; adjust as necessary.
s3_bucket_name = "my-lambda-s3-bucket"

# IAM Role for Lambda
# Note: This name is taken from your IAM policy. Adjust if different.
lambda_iam_role_name = "lambda-lambdaRole-waf"

# EventBridge Rule
# Note: Default values based on your EventBridge configuration.
eventbridge_rule_name = "run-lambda-function-every-2-minutes"
eventbridge_schedule_expression = "rate(2 minutes)"
