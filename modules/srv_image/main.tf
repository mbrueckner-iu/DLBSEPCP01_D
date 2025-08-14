resource "aws_launch_template" "srv_image" {
  name_prefix = "launch_template_"
  image_id = "ami-02457590d33d576c3"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = base64encode(<<EOF
              #!/bin/bash
              echo "Hello, World. Welcome to the use of Terraform in deploying infrastructure" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  )
  
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "webserver-by-tf"
  }
}

resource "aws_security_group" "instance" {
    name = "secgrp-instance-by-tf"

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}