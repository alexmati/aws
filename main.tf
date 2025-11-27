# Create an AWS Organization
resource "aws_organizations_organization" "org" {
  feature_set = "ALL"
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

