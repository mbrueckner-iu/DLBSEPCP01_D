output "internal_vpc_primary_setting_id" {
    value = aws_vpc.primary_setting.id
    sensitive = true
}

output "internal_subnet_public_id" {
    value = aws_subnet.public[*].id
    sensitive = true
}

output "internal_subnet_private_id" {
    value = aws_subnet.private[*].id
    sensitive = true
}