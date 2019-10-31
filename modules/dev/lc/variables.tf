variable "cluster_name" {}

variable "name" {}

variable "env" {}

variable "vpc" {}

variable "subnet" {}

variable "image" {}

variable "security_group_node" {}

variable "iam_role_node_name" {}

variable "eks_cluster_endpoint" {}

variable "eks_cluster_certificate" {}

variable "instance_type" {
  description = "The type of EC2 instance"
  default = "t2.micro"
}

variable "tags" {
  type    = "map"
  default = {}
}
