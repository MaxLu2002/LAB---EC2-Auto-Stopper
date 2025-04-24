resource "random_id" "bucket_id" {
  byte_length = 4
}

locals {
  bucket_names = [for i in range(var.bucket_count) : "${var.tags["Name"]}-${i + 1}-${random_id.bucket_id.hex}"]
}

resource "aws_s3_bucket" "buckets" {
  count  = var.bucket_count
  bucket = local.bucket_names[count.index]
  tags   = var.tags
}
