resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state"

  tags = {
    Name        = "terraform-state"
    Terraform   = "true"
    Environment = "management"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

