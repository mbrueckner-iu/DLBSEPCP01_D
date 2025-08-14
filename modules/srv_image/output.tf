output "launch_template_srv_image_id" {
    value = aws_launch_template.srv_image.id
    sensitive = true
}