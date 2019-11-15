resource "aws_key_pair" "key_pair_ec2" {
  key_name  	= "key-pair-${var.name}-${var.env}"
  public_key 	= "${file("./keys/ssh_dev_key_ec2.pub")}"
}

