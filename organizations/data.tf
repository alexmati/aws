data "aws_iam_policy_document" "s3_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      "${aws_s3_bucket.terraform_state.arn}",
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:prefix"
      values = [
        "aws/organizations/key.tflock"
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.terraform_state.id}/aws/organizations/key.tflock"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = [
      "${aws_s3_bucket.terraform_state.id}/aws/organizations/key.tflock"
    ]
  }
}
