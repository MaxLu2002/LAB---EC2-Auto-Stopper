resource "aws_s3_bucket_policy" "bucket_policies" {
  count  = var.bucket_count
  bucket = aws_s3_bucket.buckets[count.index].id
  policy = data.template_file.s3_bucket_policy[count.index].rendered
}
