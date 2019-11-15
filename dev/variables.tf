variable "name" {
  default = "projectname"
  description = "The name of project"
}

variable "env" {
  description = "Environment name"
  default = "dev"
}

variable "region" {
  description = "Region that the instances will be created"
  default = "us-east-1"
}

variable "profile" {
  description = "The profile you want to use"
  default     = "default"
}

