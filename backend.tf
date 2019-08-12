# Backend configuration is loaded early so we can't use variables

terraform {
  backend "s3" {
    region  = "eu-west-3"
    bucket  = "bucket-s3.ldelatte.tests.terraform"
    key     = "state.tfstate"
    encrypt = true
  }
}
