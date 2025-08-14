resource "aws_security_group" "alb" {
  name = "secgrp-alb-by-tf"

  # Allow inbound HTTP requests
  ingress {
        from_port = 80 
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

   # Allow oubound requests
  egress {
        from_port = 0 
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb_target_group" "web_srv" {
  name = "lb-target-group-by-tf"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id
  
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

data "aws_subnets" "vpc_subnet" {
  
}

data "aws_vpc" "default" {
  
}