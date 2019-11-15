variable "name" {}

variable "env" {}

variable "region" {}

variable "ami" {}

variable "key_pair" {}

variable "security_group_public" {}

variable "security_group_private" {}

variable "subnet_public" {}

variable "subnet_private" {}

data "aws_availability_zones" "available" {}

variable "instance_type" {
  description = "The type of ec2 instance"
//  default = "t2.micro"
  default = "t2.large"
}

variable "volume_type" {
  description = "The type of volume"
  default = "standard"
}

variable "volume_size" {
  description = "The size of volume"
  default = "8"
}

variable "iops" {
  description = "The count of iops"
  default = "0"
}

variable "tags" {
  type    = "map"
  default = {}
}

