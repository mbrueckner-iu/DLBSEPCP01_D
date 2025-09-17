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

# Route53 alarms
resource "aws_route53_health_check" "cf_alarm" {
  fqdn = var.internal_cloudfront_distribution_primary_setting_dns_name
  port = 443
  type = "HTTPS"
  resource_path = "/"
  failure_threshold = 3
  request_interval = 30
  cloudwatch_alarm_region = var.aws_region
  cloudwatch_alarm_name = "${var.aws_installation_name}-cf-alarm"
  insufficient_data_health_status = "Unhealthy"

  tags = {
    Name = "${var.aws_installation_name}-route53-health-check-cf-alarm"
  }
}

# Alarm notification
resource "aws_sns_topic" "health_check_alarm" {
  name = "${var.aws_installation_name}-health-check-alarm"

  tags = {
    Name = "${var.aws_installation_name}-sns-health-check-alarm"
  }
}

resource "aws_sns_topic_subscription" "mail_alert" {
  count = length(var.monitoring_alarm_mail_addresses)
  topic_arn = aws_sns_topic.health_check_alarm.arn
  protocol = "email"
  endpoint = var.monitoring_alarm_mail_addresses[count.index]
}