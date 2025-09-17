terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Provider and AWS region
provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Module for AWS network settings
module "network" {
  source = "./modules/network"
  aws_vpc_cidr = var.aws_vpc_cidr
  aws_installation_name = var.aws_installation_name
  aws_az_list = var.aws_az_list
}

# Module for AWS S3
module "storage" {
  source = "./modules/storage"
  depends_on = [ module.network ]
  aws_installation_name = var.aws_installation_name
}

# Sleep after creation of AWS network
resource "time_sleep" "wait_after_network" {
  depends_on      = [ module.storage ]
  create_duration = var.sleeping_time
}

# Module for AWS security groups and IAM
module "security" {
  source = "./modules/security"
  depends_on = [ time_sleep.wait_after_network ]
  aws_vpc_cidr = var.aws_vpc_cidr
  aws_installation_name = var.aws_installation_name
  internal_vpc_primary_setting_id = module.network.internal_vpc_primary_setting_id
  internal_s3_bucket_primary_storage_arn = module.storage.internal_s3_bucket_primary_storage_arn
}

# Module for AWS application load balancer
module "loadbalancer" {
  source = "./modules/loadbalancer"
  depends_on = [ module.security ]
  aws_installation_name = var.aws_installation_name
  internal_vpc_primary_setting_id = module.network.internal_vpc_primary_setting_id
  internal_security_group_alb_cf_access_80_id = module.security.internal_security_group_alb_cf_access_80_id
  internal_security_group_alb_cf_access_443_id = module.security.internal_security_group_alb_cf_access_443_id
  internal_subnet_public_id = module.network.internal_subnet_public_id
}

# Sleep after creation of AWS application load balancer
resource "time_sleep" "wait_after_loadbalancer" {
  depends_on      = [ module.loadbalancer ]
  create_duration = var.sleeping_time
}

# Module for AWS EC2 instances
module "server" {
  source = "./modules/server"
  depends_on = [ time_sleep.wait_after_loadbalancer ]
  aws_installation_name = var.aws_installation_name
  aws_instance_type = var.aws_instance_type
  internal_security_group_websrv_access_id = module.security.internal_security_group_websrv_access_id
  internal_subnet_private_id = module.network.internal_subnet_private_id
  internal_lb_target_group_websrv_arn = module.loadbalancer.internal_lb_target_group_websrv_arn
  internal_s3_bucket_primary_storage_name = module.storage.internal_s3_bucket_primary_storage_name
  internal_iam_instance_profile_server_name = module.security.internal_iam_instance_profile_server_name
}

# Sleep after creation of AWS EC2 instances
resource "time_sleep" "wait_after_server" {
  depends_on      = [ module.server ]
  create_duration = var.sleeping_time
}

# Module for AWS cloud front
module "cdn" {
  source = "./modules/cdn"
  depends_on = [ time_sleep.wait_after_server ]
  aws_installation_name = var.aws_installation_name
  internal_lb_primary_setting_name = module.loadbalancer.internal_lb_primary_setting_name
  internal_lb_primary_setting_dns_name = module.loadbalancer.internal_lb_primary_setting_dns_name
  internal_s3_bucket_primary_storage_id = module.storage.internal_s3_bucket_primary_storage_id
  internal_s3_bucket_primary_storage_arn = module.storage.internal_s3_bucket_primary_storage_arn
  internal_s3_bucket_primary_storage_regional_domain_name = module.storage.internal_s3_bucket_primary_storage_regional_domain_name
  internal_iam_role_server_storage_arn = module.security.internal_iam_role_server_storage_arn
}

# Module for AWS cloud watch
module "monitoring" {
  source = "./modules/monitoring"
  depends_on = [ module.cdn ]
  aws_installation_name = var.aws_installation_name
  aws_region = var.aws_region
  monitoring_alarm_mail_addresses = var.monitoring_alarm_mail_addresses
  internal_autoscaling_policy_up_arn = module.server.internal_autoscaling_policy_up_arn
  internal_autoscaling_policy_down_arn = module.server.internal_autoscaling_policy_down_arn
  internal_autoscaling_group_websrv_name = module.server.internal_autoscaling_group_websrv_name
  internal_cloudfront_distribution_primary_setting_dns_name = module.cdn.internal_cloudfront_distribution_primary_setting_dns_name
  internal_lb_primary_setting_dns_name = module.loadbalancer.internal_lb_primary_setting_dns_name
}