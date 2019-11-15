// Amazon Virtual Private Cloud
module "vpc" {
  source                	= "../modules/dev/vpc"
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
  name                  	= "${var.name}"
  env                   	= "${var.env}"
  vpc                		= "${module.vpc.vpc_id}"

  tags = {
    Infra               	= "${var.name}"
    Environment                 = "${var.env}"
    Terraformed         	= "true"
  }
}

// Amazon NAT Gateways
module "natgw" {
  source                        = "../modules/dev/natgw"
  name                          = "${var.name}"
  env                           = "${var.env}"
  subnet_public             	= "${module.subnet.subnet_public_id}"

  tags = {
    Infra                       = "${var.name}"
    Environment                 = "${var.env}"
    Terraformed                 = "true"
  }
}

// Amazon Route Tables
module "rtb" {
  source                        = "../modules/dev/rtb"
  name                          = "${var.name}"
  env                           = "${var.env}"
  vpc                           = "${module.vpc.vpc_id}"
  ig_gateway			= "${module.ig.ig_id}"
  nat_gateway			= "${module.natgw.nat_gateway_id}"
  subnet_public			= "${module.subnet.subnet_public_id}"
  subnet_private		= "${module.subnet.subnet_private_id}"

  tags = {
    Infra                       = "${var.name}"
    Environment                 = "${var.env}"
    Terraformed                 = "true"
  }
}

// Amazon Security Groups
module "sg" {
  source                	= "../modules/dev/sg"
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
  name                          = "${var.name}"
  env                           = "${var.env}"

  tags = {
    Infra                       = "${var.name}"
    Environment                 = "${var.env}"
    Terraformed                 = "true"
  }
}

// Amazon Key Pairs
module "key" {
  source                        = "../modules/dev/key"
  name                          = "${var.name}"
  env                           = "${var.env}"

  tags = {
    Infra                       = "${var.name}"
    Environment                 = "${var.env}"
    Terraformed                 = "true"
  }
}

// Amazon EC2 Instances
module "ec2" {
  source                        = "../modules/dev/ec2"
  name                          = "${var.name}"
  env                           = "${var.env}"
  region                        = "${var.region}"
  ami                          	= "${module.ami.ami_ami_id}"
  key_pair                      = "${module.key.key_pair_ec2_id}"
  security_group_public         = "${module.sg.sg_public_id}"
  security_group_private        = "${module.sg.sg_private_id}"
  subnet_public             	= "${module.subnet.subnet_public_id}"
  subnet_private		= "${module.subnet.subnet_private_id}"

  tags = {
    Infra                       = "${var.name}"
    Environment                 = "${var.env}"
    Terraformed                 = "true"
  }
}
