resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

resource "aws_iam_role_policy" "s3_state_bucket" {
  name = "s3-state-bucket-access"
  role = aws_iam_role.github_oidc.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:PutBucketVersioning",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetBucketVersioning",
          "s3:GetBucketPublicAccessBlock"
        ],
        Resource = "arn:aws:s3:::organizations-terraform-state-123"
      },
      {
        Sid    = "AllowObjectReadWrite"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::organizations-terraform-state-123/*"
      }
    ]
  })
}

resource "aws_iam_role" "github_oidc" {
  name = "github-actions-oidc"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" : "repo:alexmati/aws:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

resource "random_string" "suffix" {
  length  = 3
  numeric = true
  upper   = false
  lower   = false
  special = false
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-${random_string.suffix.result}"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_block_all" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_budgets_budget" "daily_actual_costs" {
  name              = "daily-actual-costs"
  budget_type       = "COST"
  limit_amount      = var.daily_limit
  limit_unit        = "USD"
  time_period_end   = "2087-06-15_00:00"
  time_period_start = "2025-11-01_00:00"
  time_unit         = "DAILY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.daily_threshold
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.budget_notification_email]
  }
}

resource "aws_budgets_budget" "monthly_forecasted_costs" {
  name              = "monthly-forecasted-costs"
  budget_type       = "COST"
  limit_amount      = var.monthly_limit
  limit_unit        = "USD"
  time_period_end   = "2087-06-15_00:00"
  time_period_start = "2025-11-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.monthly_threshold
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.budget_notification_email]
  }
}

resource "aws_budgets_budget" "monthly_actual_costs" {
  name              = "monthly-actual-costs"
  budget_type       = "COST"
  limit_amount      = var.monthly_limit
  limit_unit        = "USD"
  time_period_end   = "2087-06-15_00:00"
  time_period_start = "2025-11-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.monthly_threshold
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.budget_notification_email]
  }
}

resource "aws_ce_anomaly_monitor" "service_monitor" {
  name              = "aws-service-monitor"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}

resource "aws_ce_anomaly_subscription" "service_monitor_subscription" {
  name      = "daily-subscription"
  frequency = "DAILY"

  monitor_arn_list = [
    aws_ce_anomaly_monitor.service_monitor.arn
  ]

  subscriber {
    type    = "EMAIL"
    address = var.budget_notification_email
  }

  threshold_expression {
    dimension {
      key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      match_options = ["GREATER_THAN_OR_EQUAL"]
      values        = var.anomaly_threshold
    }
  }
}