resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function_name
  package_type  = "Image"
  image_uri     = var.image_uri
  role          = aws_iam_role.lambda_role.arn
  timeout       = 10
}

