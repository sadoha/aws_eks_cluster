variable "cluster_name" {}

variable "name" {}

variable "env" {}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
  default = "10.10.0.0/16"
}

variable "tags" {
  type    = "map"
  default = {}
}
