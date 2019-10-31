variable "cluster_name" {}

variable "name" {}

variable "env" {}

variable "vpc" {}

variable "subnet" {}

variable "security_group" {}

variable "iam_role_arn" {}

variable "iam_role_name" {}

variable "iam_role_node_name" {}

variable "tags" {
  type    = "map"
  default = {}
}
