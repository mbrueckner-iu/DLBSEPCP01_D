variable "aws_installation_name" {
  description = "Name of your AWS installation. Default: iu-cp"
  type = string
  default = "iu-cp"
}

variable "aws_installation_environment" {
  description = "Specify the environment, like dev, test, or prod. Default: test"
  type = string
  default = "test"
}

variable "aws_installation_managed_by" {
  description = "Specify who is managing the installation. Default: terraform"
  type = string
  default = "terraform"
}

variable "aws_installation_owner" {
  description = "Specify who is the owner of the installation. Default: john doe"
  type = string
  default = "john doe"
}

variable "aws_region" {
  description = "Region of your AWS instance. Default: us-east-1"
  type        = string
  default     = "us-east-1"
}

variable "aws_az_list" {
  description = "List of used AWS availability zones. Default: us-east-1a, us-east-1b"
  type = list(string)
  default = [ "us-east-1a", "us-east-1b" ]
}

variable "aws_access_key" {
  description = "Get Access - DO NOT STORE KEY IN SCRIPT!"
  type = string
}

variable "aws_secret_key" {
  description = "Get Access - DO NOT STORE KEY IN SCRIPT!"
  type = string
}

variable "aws_vpc_cidr" {
  description = "CIDR IP address range for AWS VPC. Default: 10.0.0.0/16"
  type = string
  default = "10.0.0.0/16"
}

variable "aws_instance_type" {
  description = "Instance type for EC2. Default: t3a.micro"
  type        = string
  default     = "t3a.micro"
}

variable "aws_instance_type_min_size" {
  description = "Set the minimum size of running EC2 instances. Default: 2"
  type = number
  default = 2
}

variable "aws_instance_type_max_size" {
  description = "Set the maximum size of running EC2 instances. Default: 10"
  type = number
  default = 10
}

variable "aws_instance_type_ami_image" {
  description = "Set the AMI image for EC2 instances. Default: amzn2-ami-hvm-*-x86_64-gp2"
  type = string
  default = "amzn2-ami-hvm-*-x86_64-gp2"
}

variable "sleeping_time" {
  description = "Set the sleeping time. Process is waiting after finishing one configuration step, that service will be online. Default: 30s"
  type        = string
  default     = "30s"
}

variable "monitoring_alarm_mail_addresses" {
  description = "Addresses used to sent notifications, if a service will fail. Default: john.doe@example.com"
  type = list(string)
  default = [ "john.doe@example.com" ]
}