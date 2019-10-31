// This data source is included for ease of sample architecture deployment
// and can be swapped out as necessary.

data "aws_region" "current" {}

// The below is an example IAM role and policy to allow the worker nodes to 
// manage or retrieve data from other AWS services. It is used by Kubernetes 
// to allow worker nodes to join the cluster.

resource "aws_iam_instance_profile" "eks_node" {
  name 				= "eks-node-${var.name}-${var.env}"
  role 				= "${var.iam_role_node_name}"
}

// EKS currently documents this required userdata for EKS worker nodes to
// properly configure Kubernetes applications on the EC2 instance.
// We implement a Terraform local here to simplify Base64 encoding this
// information into the AutoScaling Launch Configuration.
// More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html

locals {
  eks_node_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${var.eks_cluster_endpoint}' --b64-cluster-ca '${var.eks_cluster_certificate}' '${var.cluster_name}'
USERDATA
}

resource "aws_launch_configuration" "eks_cluster" {
  associate_public_ip_address 	= "true"
  iam_instance_profile        	= "${aws_iam_instance_profile.eks_node.name}"
  image_id                    	= "${var.image}"
  instance_type               	= "${var.instance_type}"
  name_prefix                 	= "eks-node-${var.name}-${var.env}"
  security_groups             	= ["${var.security_group_node}"]
  user_data_base64            	= "${base64encode(local.eks_node_userdata)}"

  lifecycle {
    create_before_destroy 	= "true"
  }
}
