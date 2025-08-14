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
  access_key = var.access_key
  secret_key = var.secret_key
}

# Module for AWS VPC
module "vpc" {
  source = "./modules/vpc"
  server_port = var.server_port
}

# Sleep after creation of AWS VPC
resource "time_sleep" "wait_after_vpc" {
  depends_on      = [module.vpc]
  create_duration = var.sleeping_time
}

# Module for AWS AMI creation
module "srv_image" {
  depends_on = [time_sleep.wait_after_vpc]
  source     = "./modules/srv_image"
  server_port = var.server_port
}

# Sleep after creation of AWS AMI
resource "time_sleep" "wait_after_ami" {
  depends_on      = [module.srv_image]
  create_duration = var.sleeping_time
}

module "autoscaling_group" {
  depends_on   = [time_sleep.wait_after_ami]
  source       = "./modules/autoscaling_group"
  asg_min_size = var.asg_min_size
  asg_max_size = var.asg_max_size
  launch_template_srv_image_id = module.srv_image.launch_template_srv_image_id
  targrp_websrv_arn = module.vpc.targrp_websrv_arn
  vpc_subnet_ids = module.vpc.vpc_subnet_ids
}

module "loadbalancer" {
  depends_on = [ module.autoscaling_group ]
  source = "./modules/loadbalancer"
  vpc_subnet_ids = module.vpc.vpc_subnet_ids
  secgrp_alb_id = module.vpc.secgrp_alb_id
  targrp_websrv_arn = module.vpc.targrp_websrv_arn
}