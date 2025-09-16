# ALB primary setting
resource "aws_lb" "primary_setting" {
  name = "${var.aws_installation_name}-lb"
  internal = false
  enable_deletion_protection = false
  load_balancer_type = "application"
  security_groups = [ var.internal_security_group_alb_cf_access_id ]
  subnets = var.internal_subnet_public_id

  tags = {
    Name = "${var.aws_installation_name}-lb-primary-setting"
  }
}

# ALB target group for web server
resource "aws_lb_target_group" "websrv" {
  name = "${var.aws_installation_name}-lb-target-group-websrv"
  port = 80
  protocol = "HTTP"
  vpc_id = var.internal_vpc_primary_setting_id

  health_check {
    enabled = true
    healthy_threshold = 2
    interval = 30
    matcher = "200"
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.aws_installation_name}-lb-target-group-websrv"
  }
}

# ALB listener for HTTP
resource "aws_lb_listener" "websrv_http" {
  load_balancer_arn = aws_lb.primary_setting.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.websrv.arn
  }
}