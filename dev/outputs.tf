// Amazon 
output "config_map_aws_auth" {
  value = "${module.iamroles.config_map_aws_auth}"
}
