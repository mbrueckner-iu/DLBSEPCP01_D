output "internal_lb_target_group_websrv_arn" {
    value = aws_lb_target_group.websrv.arn
    sensitive = true
}

output "internal_lb_primary_setting_name" {
    value = aws_lb.primary_setting.name
    sensitive = true
}

output "internal_lb_primary_setting_dns_name" {
    value = aws_lb.primary_setting.dns_name
    sensitive = true
}