resource "aws_cloudwatch_log_group" "my_log_group" {
  name = "/ecs/my-app-test9"
}

resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "error-filter6"
  log_group_name = aws_cloudwatch_log_group.my_log_group.name
  pattern        = "ERROR"

  metric_transformation {
    name      = "ErrorCount"
    namespace = "MyApp"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "error-alarm6"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "10"

  alarm_actions = ["arn:aws:sns:us-east-1:241533131465:my-sns-topic"]
}
