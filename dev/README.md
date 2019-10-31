To update a kubeconfig for your cluster

This example command updates the default kubeconfig file to use your cluster as the current context.

Command:

	aws eks update-kubeconfig --name example --region us-east-1

Output:

	Added new context arn:aws:eks:us-west-2:012345678910:cluster/example to /Users/ericn/.kube/config

https://docs.aws.amazon.com/cli/latest/reference/eks/update-kubeconfig.html


_To start a configuration process you have to do steps below:_

    terraform init

    terraform plan

    terraform apply
