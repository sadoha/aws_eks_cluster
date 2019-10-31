variable "cluster_name" {}

variable "name" {}

variable "env" {}

variable "subnet" {}

variable "launch_configuration" {}

variable "tags" {
  type    = "map"
  default = {}
}
