# Security group for application load balancer
resource "aws_security_group" "alb_cf_access" {
  name = "${var.aws_installation_name}-alb-cf-access"
  description = "Cloud front access"
  vpc_id = var.internal_vpc_primary_setting_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "${var.aws_installation_name}-security-group-alb-cf-access"
  }
}

# Security group for web server
resource "aws_security_group" "websrv_access" {
  name = "${var.aws_installation_name}-websrv-access"
  description = "Web server access"
  vpc_id = var.internal_vpc_primary_setting_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ var.aws_vpc_cidr ]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [ aws_security_group.alb_cf_access.id ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "${var.aws_installation_name}-security-group-websrv-access"
  }
}

# IAM role for server to storage
resource "aws_iam_role" "server_storage" {
  name = "${var.aws_installation_name}-server-storage-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${var.aws_installation_name}-iam-role-server-storage"
  }
}

# IAM policy for server to storage
resource "aws_iam_role_policy" "server_storage" {
  name = "${var.aws_installation_name}-server-storage-policy"
  role = aws_iam_role.server_storage.id

  policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ]
      Resource = [
        var.internal_s3_bucket_primary_storage_arn,
        "${var.internal_s3_bucket_primary_storage_arn}/*"
      ]
    },
    {Effect = "Allow"
      Action = [
        "cloudwatch:PutMetricData",
        "ec2:DescribeVolumes",
        "ec2:DescribeTags",
        "logs:PutLogEvents",
        "logs:CreateLogGroup",
        "logs:CreateLogStream"
      ]
      Resource = "*"
    }]
  })
}

# IAM server profile
resource "aws_iam_instance_profile" "server" {
  name = "${var.aws_installation_name}-server-profile"
  role = aws_iam_role.server_storage.name

  tags = {
    Name = "${var.aws_installation_name}-iam-instance-profile-server"
  }
}