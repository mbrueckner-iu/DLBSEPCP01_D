# Cloud watch alarms
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name = "${var.aws_installation_name}-cloudwatch-metric-alarm-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300
  statistic = "Average"
  threshold = 80
  alarm_actions = [ var.internal_autoscaling_policy_up_arn ]

  dimensions = {
    AutoScalingGroupName = var.internal_autoscaling_group_websrv_name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name = "${var.aws_installation_name}-cloudwatch-metric-alarm-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300
  statistic = "Average"
  threshold = 20
  alarm_actions = [ var.internal_autoscaling_policy_down_arn ]

  dimensions = {
    AutoScalingGroupName = var.internal_autoscaling_group_websrv_name
  }
}