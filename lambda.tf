# AWS Lambda function resource
resource "aws_lambda_function" "test_lambda_function" {
  function_name = "lambdaTest"
  package_type  = "Image"
  image_uri     = "748487089563.dkr.ecr.us-east-1.amazonaws.com/my-lambda-function:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 10
  
}
