module "s3bucket" {
  source = "./modules/s3"
  bucket_list = [
    "stg",
    "ref",
    "trn",
    "tmp",
    "athena",
    "analytic",
    "doc",
    "public",
    "art",
    "log",
    "projects",
    "iac",
    "backup",
    "landing",
    "raw"
  ]
}