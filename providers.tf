terraform {
  required_version = ">= 1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "development"
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.development.id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "uat"
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.uat.id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "production"
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.production.id}:role/OrganizationAccountAccessRole"
  }
}
