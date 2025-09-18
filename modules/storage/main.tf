# S3 bucket
resource "aws_s3_bucket" "primary_storage" {
  bucket = "${var.aws_installation_name}-s3-${random_id.dynamic_id.dec}"
}

resource "random_id" "dynamic_id" {
  byte_length = 4
}

# S3 versioning
resource "aws_s3_bucket_versioning" "primary_storage" {
  bucket = aws_s3_bucket.primary_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "primary_storage" {
  bucket = aws_s3_bucket.primary_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 public access
resource "aws_s3_bucket_public_access_block" "primary_storage" {
  bucket = aws_s3_bucket.primary_storage.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# S3 object index.html
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.primary_storage.id
  key = "index.html"
  content_type = "text/html"

  content = <<-EOF
  <!DOCTYPE html>
  <html>
   <head>
    <title>IU Cloud Programming</title>
   </head>
   <body>
    <h1>Hello! You are connected to my first AWS project!</h1>
   </body>
  </html>
  EOF
}