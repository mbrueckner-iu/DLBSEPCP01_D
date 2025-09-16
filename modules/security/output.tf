output "internal_security_group_alb_cf_access_id" {
    value = aws_security_group.alb_cf_access.id
    sensitive = true
}

output "internal_security_group_websrv_access_id" {
    value = aws_security_group.websrv_access.id
    sensitive = true
}

output "internal_iam_instance_profile_server_name" {
    value = aws_iam_instance_profile.server.name
    sensitive = true
}

output "internal_iam_role_server_storage_arn" {
    value = aws_iam_role.server_storage.arn
    sensitive = true
}