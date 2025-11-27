terraform {
  backend "s3" {
    bucket       = "organizations-terraform-state-${data.aws_caller_identity.current}"
    key          = "terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true
  }
}
