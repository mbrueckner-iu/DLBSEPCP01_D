output "internal_autoscaling_policy_up_arn" {
    value = aws_autoscaling_policy.up.arn
    sensitive = true
}

output "internal_autoscaling_policy_down_arn" {
    value = aws_autoscaling_policy.down.arn
    sensitive = true
}

output "internal_autoscaling_group_websrv_name" {
    value = aws_autoscaling_group.websrv.name
    sensitive = true
}