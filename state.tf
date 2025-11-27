resource "aws_s3_bucket" "organizations_state" {
  bucket = "organizations-terraform-state"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.organizations_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.organizations_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_iam_role.deployment.arn
        }
        Action = "s3:ListBucket"
        Resource = aws_s3_bucket.terraform_state.arn
      },
      {
        Effect = "Allow",
        Principal = {
          AWS = data.aws_iam_role.deployment.arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.terraform_state.arn}/*"
        ]
      }
    ]
  })
}