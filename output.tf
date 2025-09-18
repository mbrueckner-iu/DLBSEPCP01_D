output "application_url" {
  value       = "https://${module.cdn.internal_cloudfront_distribution_primary_setting_dns_name}"
  description = "Main access via Cloud front"
}

output "vpc_id" {
    value = module.network.internal_vpc_primary_setting_id
    description = ""
}

output "subnet_public" {
    value = module.network.internal_subnet_public_id
    description = ""
}

output "subnet_private" {
    value = module.network.internal_subnet_private_id
    description = ""
}

output "lb_dns_name" {
    value = module.loadbalancer.internal_lb_primary_setting_dns_name
    description = ""
}

output "cloudfront_dns_name" {
    value = module.cdn.internal_cloudfront_distribution_primary_setting_dns_name
    description = ""
}

output "s3_name" {
    value = module.storage.internal_s3_bucket_primary_storage_name
    description = ""
}