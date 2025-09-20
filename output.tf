output "application_url" {
  value       = "https://${module.cdn.internal_cloudfront_distribution_primary_setting_dns_name}"
  description = "Main access via Cloud front to static HTML page. Default: Access via HTTPS, all HTTP requests will be forwarded to HTTPS"
}

output "vpc_id" {
    value = module.network.internal_vpc_primary_setting_id
    description = "ID of VPC"
}

output "subnet_public" {
    value = module.network.internal_subnet_public_id
    description = "IDs of public subnet"
}

output "subnet_private" {
    value = module.network.internal_subnet_private_id
    description = "IDs of private subnet"
}

output "lb_dns_name" {
    value = module.loadbalancer.internal_lb_primary_setting_dns_name
    description = "DNS name of loadbalancer. Default: no access via HTTP and HTTPS"
}

output "cloudfront_dns_name" {
    value = module.cdn.internal_cloudfront_distribution_primary_setting_dns_name
    description = "DNS name of Cloud front. Please refer to description of application_url"
}

output "s3_name" {
    value = module.storage.internal_s3_bucket_primary_storage_name
    description = "Name of the S3 bucket"
}