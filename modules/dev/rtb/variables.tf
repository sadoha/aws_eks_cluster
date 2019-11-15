variable "name" {}

variable "env" {}

variable "vpc" {}

variable "ig_gateway" {}

variable "nat_gateway" {}

variable "subnet_public" {}

variable "subnet_private" {}

data "aws_availability_zones" "available" {}

variable "tags" {
  type    = "map"
  default = {}
}

