locals {
  accounts = {
    development = aws_organizations_account.development.id
    uat         = aws_organizations_account.uat.id
    production  = aws_organizations_account.production.id
  }
}
