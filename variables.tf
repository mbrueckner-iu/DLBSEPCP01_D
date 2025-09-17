variable "aws_installation_name" {
  description = "Name of your AWS installation. Default: IU-CP"
  type = string
  default = "iu-cp"
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

variable "sleeping_time" {
  description = "Set the sleeping time. Process is waiting after finishing one configuration step, that service will be online. Default: 30s"
  type        = string
  default     = "30s"
}

variable "monitoring_alarm_mail_addresses" {
  description = ""
  type = list(string)
  default = [ "max.brueckner@iu-study.org" ]
}