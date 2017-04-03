# Anything inside aws that terraform doesn't know about in its tfstate file is ignored.

provider "aws" {
  # vars come from terraform.tfvars - don't commit it
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

############################
### Demo Instance        ###
############################


# EC2 Instance
resource "aws_instance" "demo" {
  ami = "ami-36ed2759"
  instance_type = "t2.micro"

  key_name = "${var.aws_demo_instance_public_key}"

  tags {
    Name = "demo"
    Groups = "demo"
  }
}
