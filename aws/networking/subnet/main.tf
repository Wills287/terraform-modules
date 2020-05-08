data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_internet_gateway" "igw" {
  filter {
    name = "attachment.vpc-id"
    values = [
      var.vpc_id
    ]
  }
}

data "aws_availability_zones" "azs" {
}
