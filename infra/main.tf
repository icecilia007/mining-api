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

module "lambada_raw" {
  source = "./modules/lambda"
  aws_region         = var.aws_region
  function_name      = "raw"
  handler            = "main.main"
  scripts_dockerfile = "../scripts/raw/Dockerfile"
  scripts_local      = "../scripts/raw/main.py"
  folder = "../scripts/raw/"
}