terraform {
  backend "s3" {
    bucket       = "terraform-state"
    key          = "aws/organizations/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}