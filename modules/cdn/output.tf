output "internal_cloudfront_distribution_primary_setting_dns_name" {
    value = aws_cloudfront_distribution.primary_setting.domain_name
    sensitive = true
}