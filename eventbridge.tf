resource "aws_cloudwatch_event_rule" "eventbridge_rule" {
  name                = var.eventbridge_rule_name
  description         = "Trigger lambda function every 2 minutes"
  schedule_expression = var.eventbridge_schedule_expression
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.eventbridge_rule.arn
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.eventbridge_rule.name
  target_id = "InvokeLambdaFunction"
  arn       = aws_lambda_function.lambda_function.arn
}
