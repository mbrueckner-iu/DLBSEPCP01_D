output "internal_s3_bucket_primary_storage_regional_domain_name" {
    value = aws_s3_bucket.primary_storage.bucket_regional_domain_name
    sensitive = true
}

output "internal_s3_bucket_primary_storage_id" {
    value = aws_s3_bucket.primary_storage.id
    sensitive = true
}

output "internal_s3_bucket_primary_storage_arn" {
    value = aws_s3_bucket.primary_storage.arn
    sensitive = true
}

output "internal_s3_bucket_primary_storage_name" {
    value = aws_s3_bucket.primary_storage.bucket
    sensitive = true
}