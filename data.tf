data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "organizations_state" {
  bucket = "organizations-terraform-state-123"
}