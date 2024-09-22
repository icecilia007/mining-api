resource "aws_s3_bucket" "s3_buckets" {
  for_each = toset(var.bucket_list)
  bucket = lower("${var.env}-${var.project}-${var.s3name}-${each.key}")
}