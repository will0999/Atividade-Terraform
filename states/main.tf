provider "aws" {
  region = var.aws_region
  access_key = "AKIASBGJRBTVA45RZQTF"
  secret_key = "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"
}
resource "aws_key_pair" "ssh" {
  key_name   = "ssh_key"
  public_key = file("C:\\Users\\Thecr\\.ssh\\id_rsa.pub")
}
resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh.key_name
  tags = {
    Name = "Terraform-Web-Instance"
  }
}
# resource "aws_s3_bucket" "virt-bucket" {
#   bucket = "virt-bucket-s3"
#   acl    = "private"
#   tags = {
#     Name = "Exemplo de bucket S3"
#   }
# }
## Bucket criado manualmente na aws
terraform {
  backend "s3" {
    bucket = "bucket-virt"
    key    = "terraform.tfstate"
    region = "us-east-2"
    access_key = "AKIASBGJRBTVA45RZQTF"
    secret_key = "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"
  }
}