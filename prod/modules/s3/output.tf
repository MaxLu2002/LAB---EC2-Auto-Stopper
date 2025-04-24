output "bucket_names" {
  value       = aws_s3_bucket.buckets[*].id
  description = "The names of the S3 buckets"
}
