output "ami_eks_worker_id" {
  value = "${data.aws_ami.eks_worker.id}"
}

