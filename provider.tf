provider "aws" {
  version    = "~> 2.22"
  profile    = "default"
  region     = var.aws_region
}
