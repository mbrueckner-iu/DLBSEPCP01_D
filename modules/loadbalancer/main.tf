resource "aws_lb" "web_srv" {
    name = "alb-by-tf"
    load_balancer_type = "application"
    subnets = var.vpc_subnet_ids
    security_groups = [ var.secgrp_alb_id ]
}

resource "aws_lb_listener" "web_srv" {
  load_balancer_arn = aws_lb.web_srv.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
        content_type = "text/plain"
        message_body = "404: page not found"
        status_code = 404
    }
  }
}

resource "aws_lb_listener_rule" "web_srv" {
  listener_arn = aws_lb_listener.web_srv.arn
  priority = 100

  condition {
    path_pattern {
        values = ["*"]
    }
  }
  action {
    type = "forward"
    target_group_arn = var.targrp_websrv_arn
  }
}