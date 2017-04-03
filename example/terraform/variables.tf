variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_demo_instance_public_key" {}

variable "aws_region" {
  default = "eu-central-1"
}

variable "aws_avail_zones" {
  type = "map"

  default = {
    a = "eu-central-1a"
    b = "eu-central-1b"
  }
}
