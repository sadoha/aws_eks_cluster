variable "cluster_name" {}

variable "name" {}

variable "env" {}

variable "vpc" {}

variable "tags" {
  type    = "map"
  default = {}
}
