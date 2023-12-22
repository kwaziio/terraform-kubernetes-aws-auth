####################################
# AWS Authentication Configuration #
####################################

variable "aws_auth_accounts" {
  default     = []
  description = "List of AWS Account IDs to Associate w/ this Cluster (Adds All Users and Roles)"
  type        = list(string)
}

variable "aws_auth_roles" {
  default     = []
  description = "List of Custom AWS IAM Role Mappings for Kubernetes Users"

  type = list(object({
    groups   = list(string)
    rolearn  = string
    username = string
  }))
}

variable "aws_auth_role_nodes" {
  default     = []
  description = "ARNs of the IAM Role(s) Assigned to Kubernetes Nodes Hosted by AWS"
  type        = list(string)
}

variable "aws_auth_role_owners" {
  description = "ARNs of the AWS IAM Role(s) to Receive Unlimited System Access"
  type        = list(string)
}

variable "aws_auth_users" {
  default     = []
  description = "List of Custom AWS IAM User Mappings for Kubernetes Users"

  type = list(object({
    groups   = list(string)
    userarn  = string
    username = string
  }))
}
