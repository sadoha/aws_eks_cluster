#
# Outputs
#

output "vpc_id" {
  value = aws_vpc.eks.id
}

output "subnet_id" {
  value = aws_subnet.eks.*.id
}
