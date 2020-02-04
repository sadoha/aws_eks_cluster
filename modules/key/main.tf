resource "aws_key_pair" "key_pair" {
  key_name      = "key-pair"
  public_key    = "${file("./keys/ssh_dev_key_ec2.pub")}"
}
