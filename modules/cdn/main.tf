# Cloud front primary setting
resource "aws_cloudfront_distribution" "primary_setting" {
  enabled = true

  origin {
    domain_name = var.internal_lb_primary_setting_dns_name
    origin_id = "${var.internal_lb_primary_setting_name}-lb"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = [ "TLSv1.2" ]
    }
  }

  origin {
    domain_name = var.internal_s3_bucket_primary_storage_regional_domain_name
    origin_id = "${var.internal_s3_bucket_primary_storage_id}-s3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.primary_setting.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods = [ "DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT" ]
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = "${var.internal_lb_primary_setting_name}-lb"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 0
    max_ttl = 0

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern = "/static/*"
    allowed_methods = [ "GET", "HEAD", "OPTIONS" ]
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = "${var.internal_s3_bucket_primary_storage_id}-s3"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 86400
    max_ttl = 2592000
    compress = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "${var.aws_installation_name}-cloudfront-distribution-primary-setting"
  }
}

# Cloud front S3 access policy
resource "aws_cloudfront_origin_access_identity" "primary_setting" {
    comment = "${var.aws_installation_name}-origin-access-identity"
}

# S3 access for cloud front
resource "aws_s3_bucket_policy" "primary_storage" {
  bucket = var.internal_s3_bucket_primary_storage_id

  policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      
      Principal = {
        AWS = var.internal_iam_role_server_storage_arn
      }

      Resource = [
        var.internal_s3_bucket_primary_storage_arn,
        "${var.internal_s3_bucket_primary_storage_arn}/*"
      ]
    }]
  })
}