# Create an AWS Organization
resource "aws_organizations_organization" "org" {
  feature_set = "ALL"

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY"
  ]
}

# Organizational Units
resource "aws_organizations_organizational_unit" "development" {
  name      = "development"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "uat" {
  name      = "uat"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "production" {
  name      = "production"
  parent_id = aws_organizations_organization.org.roots[0].id
}

# Create accounts for each organization
resource "aws_organizations_account" "development" {
  name      = "Development Account"
  email     = var.development_email
  parent_id = aws_organizations_organizational_unit.development.id
}

resource "aws_organizations_account" "uat" {
  name      = "UAT Account"
  email     = var.uat_email
  parent_id = aws_organizations_organizational_unit.uat.id
}

resource "aws_organizations_account" "production" {
  name      = "Production Account"
  email     = var.production_email
  parent_id = aws_organizations_organizational_unit.production.id
}

resource "aws_organizations_policy" "deny_without_mfa" {
  name        = "DenyWithoutMFA"
  description = "Deny all actions unless MFA is enabled"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Deny",
        Action   = "*",
        Resource = "*",
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "deny_without_mfa_to_ou" {
  policy_id = aws_organizations_policy.deny_without_mfa.id
  target_id = aws_organizations_organizational_unit.development.id
}

module "github_oidc_dev" {
  source = "./modules/setup"
  providers = {
    aws = aws.development
  }

  daily_limit               = "10"
  daily_threshold           = 10
  monthly_limit             = "50"
  monthly_threshold         = 50
  budget_notification_email = var.development_email
  anomaly_threshold         = ["75"]
}

module "github_oidc_uat" {
  source = "./modules/setup"
  providers = {
    aws = aws.uat
  }

  daily_limit               = "10"
  daily_threshold           = 10
  monthly_limit             = "50"
  monthly_threshold         = 50
  budget_notification_email = var.uat_email
  anomaly_threshold         = ["75"]
}

module "github_oidc_prod" {
  source = "./modules/setup"
  providers = {
    aws = aws.production
  }

  daily_limit               = "10"
  daily_threshold           = 10
  monthly_limit             = "50"
  monthly_threshold         = 50
  budget_notification_email = var.production_email
  anomaly_threshold         = ["75"]
}