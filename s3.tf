resource "aws_s3_bucket" "bucket-s3-terraform" {
  bucket = var.nom-bucket-s3-terraform
  acl    = "private"
  tags = { Contact = var.contact, Project = var.projet }
}
