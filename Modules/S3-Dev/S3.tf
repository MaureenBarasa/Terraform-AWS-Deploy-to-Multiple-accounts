module "s3-bucket-dev" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  bucket = "S3bucketname"
  acl    = "private"
    versioning = {
    enabled = true
  }
}
