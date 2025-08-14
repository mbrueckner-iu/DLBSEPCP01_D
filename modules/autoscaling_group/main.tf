resource "aws_autoscaling_group" "asg" {
  launch_template {
    id = var.launch_template_srv_image_id
    version = "$Latest"
  }
  vpc_zone_identifier = var.vpc_subnet_ids

  target_group_arns = [ var.targrp_websrv_arn ]
  health_check_type = "ELB"

  min_size = var.asg_min_size
  max_size = var.asg_max_size

  tag {
    key = "Name"
    value = "autoscaling-group-by-tf"
    propagate_at_launch = true
  }
}