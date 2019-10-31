variable "cluster_name" {}

variable "name" {}

variable "env" {}

variable "vpc" {}

variable "gateway" {}

variable "subnet" {}

variable "tags" {
  type    = "map"
  default = {}
}

