data "template_file" "s3_bucket_policy" {
  count    = var.bucket_count
  template = file("./scripts/policy/s3_bucket_policy.json")
  vars = {
    bucket_name = local.bucket_names[count.index]
  }
}
