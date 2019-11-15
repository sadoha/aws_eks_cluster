variable "name" {}

variable "env" {}

variable "vpc" {}

data "aws_availability_zones" "available" {}

variable "tags" {
  type    = "map"
  default = {}
}
