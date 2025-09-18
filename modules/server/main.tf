# EC2 launch template
resource "aws_launch_template" "websrv" {
  name_prefix = "${var.aws_installation_name}-launch-template-websrv-"
  image_id = data.aws_ami.linux_amazon.id
  instance_type = var.aws_instance_type
  vpc_security_group_ids = [ var.internal_security_group_websrv_access_id ]

  iam_instance_profile {
    name = var.internal_iam_instance_profile_server_name
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              aws s3 cp s3://${var.internal_s3_bucket_primary_storage_name}/index.html /var/www/html/index.html
              yum install -y amazon-cloudwatch-agent
              systemctl restart httpd
              EOF
  )
}

# Auto scaling group
resource "aws_autoscaling_group" "websrv" {
  name = "${var.aws_installation_name}-autoscaling-group-websrv"
  vpc_zone_identifier = var.internal_subnet_private_id
  target_group_arns = [ var.internal_lb_target_group_websrv_arn ]
  health_check_type = "ELB"
  health_check_grace_period = 300
  min_size = var.aws_instance_type_min_size
  max_size = var.aws_instance_type_max_size
  desired_capacity = 2

  launch_template {
    id = aws_launch_template.websrv.id
    version = "$Latest"
  }
}

# Auto scaling policies
resource "aws_autoscaling_policy" "up" {
  name = "${var.aws_installation_name}-autoscaling-policy-up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.websrv.name
}

resource "aws_autoscaling_policy" "down" {
  name = "${var.aws_installation_name}-autoscaling-policy-down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.websrv.name
}

# Ami image
data "aws_ami" "linux_amazon" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = [ var.aws_instance_type_ami_image ]
  }
}