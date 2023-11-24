resource "aws_iam_role" "lambda_role" {  
  name = "lambda-lambdaRole-waf"  
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy"{
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# S3 Access Policy
data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      "${aws_s3_bucket.my_bucket.arn}",
      "${aws_s3_bucket.my_bucket.arn}/*"
    ]
  }
}

#
# Define a Policy Document for CloudWatch Logs Permissions
#
data "aws_iam_policy_document" "lambda_logging_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

#
# Create an IAM Policy from the Policy Document
#
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging_policy"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging_policy.json
}

#
# Attach the Logging Policy to the Lambda Execution Role
#
resource "aws_iam_role_policy_attachment" "lambda_logs_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}


resource "aws_iam_policy" "s3_access" {
  name   = "s3_access"
  policy = data.aws_iam_policy_document.s3_access_policy.json
}

#
# Attach the S3 Policy to the Lambda Execution Role
#
resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}