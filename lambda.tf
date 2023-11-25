# AWS Lambda Layer for Pyarrow
resource "aws_lambda_layer_version" "pyarrow_layer" {
  filename   = "${path.module}/lambda_layers/polars_layer.zip"  # Update this path
  layer_name = "pyarrow_layer"

  # Additional configurations (like compatible runtimes) can be added here
}

# AWS Lambda Layer for Polars
resource "aws_lambda_layer_version" "polars_layer" {
  filename   = "${path.module}/lambda_layers/pyarrow_layer.zip"  # Update this path
  layer_name = "polars_layer"

  # Additional configurations can be added here
}

# AWS Lambda function resource
resource "aws_lambda_function" "test_lambda_function" {
  function_name = "hello_world_lambda"
  package_type  = "Zip"
  filename      = "${path.module}/lambda_layers/lambda_function.zip"
  handler       = "lambda_function.lambda_handler" # 'lambda_function' is the file name, 'lambda_handler' is the function name
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.11"  # Specify the correct runtime
  timeout       = 10

  layers = [
    aws_lambda_layer_version.pyarrow_layer.arn,
    aws_lambda_layer_version.polars_layer.arn
  ]
}