terraform {
  backend "s3" {
    bucket       = "organizations-terraform-state-123"
    key          = "terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true
  }
}
