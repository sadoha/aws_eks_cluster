data "template_file" "bastion_template_file" {
  template = "${file("templates/bastion_template_file.tpl")}"

  vars = {
    name                        = "${var.name}"
    env                         = "${var.env}"
  }
}

// Bastion 
resource "aws_instance" "instance_bastion" {
  ami                         	= "${var.ami}"
  instance_type               	= "${var.instance_type}"
  key_name                    	= "${var.key_pair}"
  subnet_id                   	= "${var.subnet_public[0]}"
  associate_public_ip_address 	= "true"
  monitoring                  	= "true"
  vpc_security_group_ids      	= ["${var.security_group_public}"]
  user_data                     = "${data.template_file.bastion_template_file.rendered}"
  private_ip			= "10.10.10.100"

  root_block_device {
    volume_type 		= "${var.volume_type}"
    volume_size 		= "${var.volume_size}"
    iops                  	= "${var.iops}"
    encrypted             	= "false"
    delete_on_termination 	= "true"
  }

  volume_tags = {
    Name                	= "ebs-bastion-${data.aws_availability_zones.available.names[0]}-${var.env}-${var.name}"
    Infra               	= "${var.name}"
    Terraformed         	= "true"
    Snapshot            	= "${var.env}"
  }

  tags = "${
    map(
     "Name", "ec2-bastion-${data.aws_availability_zones.available.names[0]}-${var.name}-${var.env}",
    )
  }"
}

data "template_file" "clients_template_file" {
  count				= "2"
  template = "${file("templates/client${count.index}_template_file.tpl")}"

  vars = {
    name                        = "${var.name}"
    env                         = "${var.env}"
  }
}

// Clients
resource "aws_instance" "instance_clients" {
  count                         = "2"
  ami                           = "${var.ami}"
  instance_type                 = "${var.instance_type}"
  key_name                      = "${var.key_pair}"
  subnet_id                     = "${var.subnet_private[count.index]}"
  associate_public_ip_address   = "false"
  monitoring                    = "true"
  vpc_security_group_ids        = ["${var.security_group_private}"]
  user_data                     = "${data.template_file.clients_template_file[count.index].rendered}"
  private_ip			= "10.10.2${count.index}.100"

  root_block_device {
    volume_type                 = "${var.volume_type}"
    volume_size                 = "${var.volume_size}"
    iops                        = "${var.iops}"
    encrypted                   = "false"
    delete_on_termination       = "true"
  }

  volume_tags = {
    Name                        = "ebs-client-${data.aws_availability_zones.available.names[count.index]}-${var.env}-${var.name}"
    Infra                       = "${var.name}"
    Terraformed                 = "true"
    Snapshot                    = "${var.env}"
  }

  tags = "${
    map(
     "Name", "ec2-client-${data.aws_availability_zones.available.names[count.index]}-${var.name}-${var.env}",
    )
  }"
}

