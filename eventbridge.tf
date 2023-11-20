# Define the EventBridge Rule: This is similar to defining a CloudWatch Event Rule. 
# You specify the schedule for every 2 minutes using a cron expression.
resource "aws_cloudwatch_event_rule" "eventbridge_rule" {
  name                = "run-lambda-function-every-2-minutes"
  description         = "Trigger lambda function every 2 minutes"
  schedule_expression = "rate(2 minutes)"
}

# Set Up the Lambda Permission: This allows EventBridge (events.amazonaws.com) to invoke your Lambda function.
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.eventbridge_rule.arn
}

# Create an EventBridge Target: This connects your EventBridge rule to the Lambda function.
# You need to specify the ARN of your Lambda function as the target.
resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.eventbridge_rule.name
  target_id = "InvokeLambdaFunction"
  arn       = aws_lambda_function.test_lambda_function.arn
}
