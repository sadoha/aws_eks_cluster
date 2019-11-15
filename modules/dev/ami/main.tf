data "aws_ami" "ami" {
  filter {
    name   = "name"
    values = ["CentOS 7*"]
  }

  most_recent = true
  owners      = ["amazon"] # Amazon AMI Account ID

  tags = "${
    map(
     "Name", "vpc-${var.name}-${var.env}",
    )
  }"
}
