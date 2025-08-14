variable "aws_region" {
  description = "Set the correct region of your AWS instance. Default: us-east-1"
  type        = string
  default     = "us-east-1"
}

variable "sleeping_time" {
  description = "Set the sleeping time. Process is waiting after finishing one configuration step, that service will be online. Default: 30s"
  type        = string
  default     = "30s"
}

variable "instance_type" {
  description = "value"
  type        = string
  default     = "t2.micro"
}

variable "asg_min_size" {
  description = "value"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "value"
  type        = number
  default     = 10
}

variable "server_port" {
  description = "Port to be used from webserver for HTTP requests"
  type = number
  default = 8080
}

variable "access_key" {
  description = "Get Access"
  type = string
}

variable "secret_key" {
  description = "Get Access"
  type = string
}