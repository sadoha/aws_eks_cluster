resource "aws_security_group" "sg_public" {
  name        		= "public-${var.name}-${var.env}"
  description 		= "The public network communication"
  vpc_id      		= "${var.vpc}"

  egress {
    from_port   	= 0
    to_port     	= 0
    protocol    	= "-1"
    cidr_blocks 	= ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "sg-public-${var.name}-${var.env}",
    )
  }"
}

resource "aws_security_group" "sg_private" {
  name        		= "private-${var.name}-${var.env}"
  description 		= "The private network communication"
  vpc_id      		= "${var.vpc}"

  egress {
    from_port   	= 0
    to_port    	 	= 0
    protocol    	= "-1"
    cidr_blocks 	= ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "sg-private-${var.name}-${var.env}",
    )
  }"
}

resource "aws_security_group_rule" "ingress_public_icmp" {
  cidr_blocks           = ["0.0.0.0/0"]
  description           = "Allow communicate ICMP"
  from_port             = "8"
  protocol              = "icmp"
  security_group_id     = "${aws_security_group.sg_public.id}"
  to_port               = "0"
  type                  = "ingress"
}

resource "aws_security_group_rule" "ingress_private_icmp" {
  cidr_blocks           = ["0.0.0.0/0"]
  description           = "Allow communicate ICMP"
  from_port             = "8"
  protocol              = "icmp"
  security_group_id     = "${aws_security_group.sg_private.id}"
  to_port               = "0"
  type                  = "ingress"
}

resource "aws_security_group_rule" "ingress_public_ssh" {
  cidr_blocks           = ["0.0.0.0/0"]
  description           = "Allow communicate with a SSH service"
  from_port             = "22"
  protocol              = "tcp"
  security_group_id     = "${aws_security_group.sg_public.id}"
  to_port               = "22"
  type                  = "ingress"
}

resource "aws_security_group_rule" "ingress_from_private_to_public" {
  description              = "Allow communication between public and private networks"
  from_port                = "1025"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.sg_public.id}"
  source_security_group_id = "${aws_security_group.sg_private.id}"
  to_port                  = "65535"
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_from_public_to_private" {
  description              = "Allow communication between public and private networks"
  from_port                = "1025"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.sg_private.id}"
  source_security_group_id = "${aws_security_group.sg_public.id}"
  to_port                  = "65535"
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_from_public_to_private_ssh" {
  description              = "Allow SSH communication between public and private networks"
  from_port                = "22"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.sg_private.id}"
  source_security_group_id = "${aws_security_group.sg_public.id}"
  to_port                  = "22"
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_private" {
  description              = "Allow communication inside of private networks"
  from_port                = "0"
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.sg_private.id}"
  source_security_group_id = "${aws_security_group.sg_private.id}"
  to_port                  = "65535"
  type                     = "ingress"
}

