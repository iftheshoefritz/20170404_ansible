# Anything inside aws that terraform doesn't know about in its tfstate file is ignored. If you create a
# resource with the same name as an existing one, you will end up with two of the same resource

provider "aws" {
  # vars come from terraform.tfvars - don't commit it
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

#resource "aws_vpc" "demo" {
#  cidr_block = "10.0.0.0/16" # overlapping IP blocks will prevent VPCs from being connected to each other
#  enable_dns_hostnames = true
#  tags {
#    Name = "test"
#  }
#}

#resource "aws_security_group" "public_access" {
#  name        = "Demo Public Security Group"
#  description = "Demo Public Security Group"
#  vpc_id      = "${aws_vpc.demo.id}"
#
#  ingress {
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  ingress {
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  ingress {
#    from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  # outbound internet access
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}

############################
### Demo Instance        ###
############################


# EC2 Instance
resource "aws_instance" "demo" {
  #ami           = "${aws_ami_copy.test_ubuntu_16_04.id}"
  ami = "ami-36ed2759"
  instance_type = "t2.micro"

  key_name = "fritz"
  #subnet_id = "${aws_subnet.services.id}"
  #vpc_security_group_ids = [
  #  "${aws_security_group.bastion_access.id}",
  #]

  tags {
    Name = "demo"
    Groups = "demo"
  }
}
