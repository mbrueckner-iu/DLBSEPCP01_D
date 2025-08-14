output "secgrp_alb_id" {
    value = aws_security_group.alb.id
    sensitive = true
}

output "targrp_websrv_arn" {
    value = aws_lb_target_group.web_srv.arn
    sensitive = true
}

output "vpc_subnet_ids" {
    value = data.aws_subnets.vpc_subnet.ids
    sensitive = true
}