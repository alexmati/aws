# Create an AWS Organization
resource "aws_organizations_organization" "org" {
  feature_set = "ALL"
}

# Create Sandbox Organizational Unit
resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "sandbox"
  parent_id = aws_organizations_organization.org.roots[0].id
}

# Create Pre-production Organizational Unit
resource "aws_organizations_organizational_unit" "preprod" {
  name      = "pre-production"
  parent_id = aws_organizations_organization.org.roots[0].id
}

# Create Production Organizational Unit
resource "aws_organizations_organizational_unit" "prod" {
  name      = "production"
  parent_id = aws_organizations_organization.org.roots[0].id
}