// Amazon Virtual Private Cloud
module "vpc" {
  source                	= "../modules/dev/vpc"
  cluster_name                  = "${var.cluster_name}"
  name                  	= "${var.name}"
  env                   	= "${var.env}"

  tags = {
    Infra               	= "${var.name}"
    Environment                 = "${var.env}"
    Terraformed         	= "true"
  }
}

// Amazon Internet Gateways
module "ig" {
  source                	= "../modules/dev/ig"
  cluster_name                  = "${var.cluster_name}"
  name                  	= "${var.name}"
  env                   	= "${var.env}"
  vpc                   	= "${module.vpc.vpc_id}"

  tags = {
    Infra               	= "${var.name}"
    Environment                 = "${var.env}"
    Terraformed         	= "true"
  }
}

// Amazon Subnet
module "subnet" {
  source                	= "../modules/dev/subnet"
  cluster_name                  = "${var.cluster_name}"
  name                  	= "${var.name}"
  env                   	= "${var.env}"
  vpc                		= "${module.vpc.vpc_id}"

  tags = {
    Infra               	= "${var.name}"
    Environment                 = "${var.env}"
    Terraformed         	= "true"
  }
}

// Amazon Route Tables
module "rtb" {
  source                        = "../modules/dev/rtb"
  cluster_name                  = "${var.cluster_name}"
  name                          = "${var.name}"
  env                           = "${var.env}"
  vpc                           = "${module.vpc.vpc_id}"
  gateway			= "${module.ig.ig_id}"
  subnet			= "${module.subnet.subnet_public_id}"

  tags = {
    Infra                       = "${var.name}"
    Environment                 = "${var.env}"
    Terraformed                 = "true"
  }
}

// Amazon IAM Roles
module "iamroles" {
  source                        = "../modules/dev/iamroles"
  cluster_name                  = "${var.cluster_name}"
  name                          = "${var.name}"
  env                           = "${var.env}"

  tags = {
    Infra                       = "${var.name}"
    Environment                 = "${var.env}"
    Terraformed                 = "true"
  }
}

// Amazon Security Groups
module "sg" {
  source                	= "../modules/dev/sg"
  cluster_name                  = "${var.cluster_name}"
  name                  	= "${var.name}"
  env                   	= "${var.env}"
  vpc                   	= "${module.vpc.vpc_id}"

  tags = {
    Infra               	= "${var.name}"
    Environment                 = "${var.env}"
    Terraformed         	= "true"
  }
}

// Amazon Linux AMI
module "ami" {
  source                        = "../modules/dev/ami"
  cluster_name                  = "${var.cluster_name}"
  name                          = "${var.name}"
  env                           = "${var.env}"

  tags = {
    Infra                       = "${var.name}"
    Environment                 = "${var.env}"
    Terraformed                 = "true"
  }
}

// Amazon Elastic Kubernetes Service
module "eks" {
  source                	= "../modules/dev/eks"
  cluster_name                  = "${var.cluster_name}"
  name                  	= "${var.name}"
  env                   	= "${var.env}"
  vpc                   	= "${module.vpc.vpc_id}"
  subnet			= "${module.subnet.subnet_public_id}"
  security_group		= "${module.sg.eks_cluster_id}"

  iam_role_arn			= "${module.iamroles.role_eks_cluster_arn}"
  iam_role_name			= "${module.iamroles.role_eks_cluster_name}"
  iam_role_node_name		= "${module.iamroles.role_eks_node_cluster_name}"

  tags = {
    Infra               	= "${var.name}"
    Environment                 = "${var.env}"
    Terraformed         	= "true"
  }
}

// Amazon Launch Configuration
module "lc" {
  source                        = "../modules/dev/lc"
  cluster_name                  = "${var.cluster_name}"
  name                          = "${var.name}"
  env                           = "${var.env}"
  vpc                           = "${module.vpc.vpc_id}"
  subnet                        = "${module.subnet.subnet_public_id}"
  security_group_node           = "${module.sg.eks_cluster_node_id}"
  image                         = "${module.ami.ami_eks_worker_id}"
  iam_role_node_name            = "${module.iamroles.role_eks_node_cluster_name}"

  eks_cluster_endpoint		= "${module.eks.eks_cluster_endpoint}"
  eks_cluster_certificate	= "${module.eks.eks_cluster_certificate}"  

  tags = {
    Infra                       = "${var.name}"
    Environment                 = "${var.env}"
    Terraformed                 = "true"
  }
}

// Amazon Autoscaling Group
module "asg" {
  source                        = "../modules/dev/asg"
  cluster_name                  = "${var.cluster_name}"
  name                          = "${var.name}"
  env                           = "${var.env}"
  subnet			= "${module.subnet.subnet_public_id}"
  launch_configuration		= "${module.lc.eks_cluster_id}"

  tags = {
    Infra                       = "${var.name}"
    Environment                 = "${var.env}"
    Terraformed                 = "true"
  }
}

