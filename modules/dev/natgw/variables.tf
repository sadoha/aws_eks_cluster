variable "name" {}

variable "env" {}

variable "subnet_public" {}

data "aws_availability_zones" "available" {}

variable "tags" {
  type    = "map"
  default = {}
}

