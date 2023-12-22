#############################################################
# Provides Information for AWS Authentication Configuration #
#############################################################

output "data" {
  description = "Kubernetes AWS Authentication Configuration Map Data"
  value       = yamlencode(kubernetes_config_map_v1_data.aws_auth.data)
}
