
provider "aws" {
  region = "us-east-2"
  access_key = "AKIASBGJRBTVEIGIPHE5"
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

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("C:\\Users\\Thecr\\.ssh\\id_rsa")
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo service httpd start"
    ]
  }
  
  provisioner "local-exec" {
    command = "echo '<html> <body><h1>Ola, Terraform!</h1></body></html>' > index.html"
  }

  provisioner "file" {
    source      = "C:\\Users\\Thecr\\Desktop\\terraform-virt-provisioners\\index.html"
    destination = "/var/www/html"
  }
}

## Bucket criado manualmente na aws
terraform {
  backend "s3" {
    bucket = "bucket-virt"
    key    = "terraform.tfstate"
    region = "us-east-2"
    access_key = "AKIASBGJRBTVEIGIPHE5"
    secret_key = "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"
  }
}