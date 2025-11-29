resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = data.aws_s3_bucket.organizations_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block_all" {
  bucket = data.aws_s3_bucket.organizations_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}