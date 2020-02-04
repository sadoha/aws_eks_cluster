// Amazon Virtual Private Cloud
module "vpc" {
  source                        = "../modules/vpc"
  projectname                   = "${var.projectname}"
  environment                  	= "${var.environment}"
  countindex                 	= "${var.countindex}"
}

// Amazon Key Pairs
module "key" {
  source                        = "../modules/key"
  projectname                   = "${var.projectname}"
  environment                  	= "${var.environment}"
  countindex                 	= "${var.countindex}"
}

// Amazon Elastic Kubernetes Service
module "eks" {
  source                        = "../modules/eks"
  projectname                   = "${var.projectname}"
  environment                   = "${var.environment}"
  countindex                    = "${var.countindex}"
  vpc_id			= "${module.vpc.vpc_id}"
  subnet_id			= "${module.vpc.subnet_id}"
  key_pair			= "${module.key.key_pair_id}"
}
