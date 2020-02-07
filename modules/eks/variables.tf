variable "projectname" {}

variable "environment" {}

variable "countindex" {}

variable "vpc_id" {}

variable "subnet_id" {}

variable "key_pair" {}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

#
# Workstation External IP
#
# This configuration is not required and is
# only provided as an example to easily fetch
# the external IP of your local workstation to
# configure inbound EC2 Security Group access
# to the Kubernetes cluster.
#

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

# Override with variable or hardcoded value if necessary
locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}

#
#  EKS Cluster
#

variable "cluster_version" {
  type          = string
  default       = "1.14"
  description   = "The version of a EKS cluster"
}

#
# EKS Worker Nodes Resources
#

variable "node_group_version" {
  type          = string
  default       = "1.14"
  description   = "The version of a EKS cluster"
}

variable "node_group_release_version" {
  type          = string
  default       = "1.14.7-20190927"
  description   = "The release version of a EKS cluster"
}

variable "node_group_instance_types" {
  type          = string
  default       = "t3.xlarge"
  description   = "The instance types of a EKS cluster"
}

variable "node_group_disk_size" {
  type          = string
  default       = "20"
  description   = "The disk size a EKS nodes"
}
