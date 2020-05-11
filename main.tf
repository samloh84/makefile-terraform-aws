provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"


  tags = merge(local.common_tags, {
    Name = "${var.project}-vpc"
  })
}

