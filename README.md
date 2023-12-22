# Terraform Kubernetes AWS Authentication Module by KWAZI

Terraform Module for Managing Amazon Web Services (AWS) Authentication for an Elastic Kubernetes Service (EKS) Cluster on AWS

## Getting Started

> NOTE: This section assumes that you have Terraform experience, have already created an AWS account, and have already configured programmatic access to that account via access token, Single-Sign On (SSO), or AWS Identity and Access Management (IAM) role. If you need help, [checkout our website](https://www.kwazi.io).

The simplest way to get started is to create a `main.tf` file with the minimum configuration options. You can use the following as a template:

```HCL
###########################
# Terraform Configuration #
###########################

terraform {
  required_version = ">= 1.6.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.21"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }
}

##############################
# AWS Provider Configuration #
##############################

provider "aws" {
  // DO NOT HARDCODE CREDENTIALS (Use Environment Variables)
}

######################################################
# Retrieves Information About the Active AWS Session #
######################################################

data "aws_caller_identity" "current" {}

############################################################
# Retrieves Information About the Targeted AWS EKS Cluster #
############################################################

data "aws_eks_cluster" "cluster" {
  name = "CLUSTER_NAME"
}

#######################################################
# Requests Temporary EKS Cluster Authentication Token #
#######################################################

data "aws_eks_cluster_auth" "admin" {
  name = "CLUSTER_NAME"
}

#####################################
# Kubernetes Provider Configuration #
#####################################

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.cluster_ca_certificate)
  host                   = data.aws_eks_cluster.cluster.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.admin.token
}

################################################################
# Example Terraform Kubernetes AWS Authentication Module Usage #
################################################################

module "terraform_kubernetes_aws_auth" {
  source = "../../"

  aws_auth_accounts    = [data.aws_caller_identity.current.account_id]
  aws_auth_role_owners = [data.aws_caller_identity.current.arn]
}

```

In the example above, you should replace the following templated values:

Placeholder | Description
--- | ---
`CLUSTER_NAME` | Replace this w/ the Name of the Targeted AWS EKS Cluster

### Granting API Access

By default, Amazon Web Services (AWS) only permits the user that created an EKS cluster to communicate with the cluster API. This module dynamically modifies the cluster's configuration to grant access based on the following variable values:

Variable | Description
--- | ---
aws_auth_accounts | Adds All IAM Users and IAM Roles to the Cluster w/ No Access Rights
aws_auth_roles | Adds IAM Roles to the Cluster w/ Specified Access
aws_auth_role_nodes | Adds IAM Roles to the Cluster that Allow Nodes to Register
aws_auth_role_owners | Adds IAM Roles to the Cluster w/ Full System Access
aws_auth_users | Adds Individual IAM Users to the Cluster w/ Specified Access

The only required variable is `aws_auth_role_owners`, as this grants access to cluster owners, allowing them to administer the cluster.

## Need Help?

Working in a strict environment? Struggling to make design decisions you feel comfortable with? Want help from an expert that you can rely on -- one who won't abandon you when the job is finished?

Check us out at [https://www.kwazi.io](https://www.kwazi.io).

## Designing a Deployment

Before launching this module, your team should agree on the following decision points:

1. Who will be granted access to the cluster?

### Who will be granted access to the cluster?

By default, Amazon Web Services (AWS) only permits the user that created an EKS cluster to communicate with the cluster API. This module dynamically modifies the cluster's configuration to grant access based several input variables.

Before granting access to users, you should first determine how users will be added to the cluster. To add all users and roles for an account, set the following variable:

```HCL
aws_auth_accounts = ["123456789"] # Replace w/ Desired AWS Account IDs
```

To grant access to individual AWS IAM roles, set the following variable:

```HCL
aws_auth_roles = [
  {
    groups = [
      "system:view", # Replace w/ Desired Kubernetes Group(s)
    ]
    rolearn  = "arn:aws:iam::123456789:role/example-role" # Replace w/ Desired ARN
    username = "guest"                                    # Replace w/ Desired Username
  }
]
```

To grant access to individual AWS IAM users, set the following variable:

```HCL
aws_auth_users = [
  {
    groups = [
      "system:view", # Replace w/ Desired Kubernetes Group(s)
    ]
    userarn  = "arn:aws:iam::123456789:user/example-user" # Replace w/ Desired ARN
    username = "guest"                                    # Replace w/ Desired Username
  }
]
```

For more information, see the section [Granting API Access.](#granting-api-access)

## Major Created Resources

The following table lists resources that this module may create in Kubernetes, accompanied by conditions for when they will or will not be created:

Resource Name | Creation Condition
--- | ---
Kubernetes Configuration Map | Always

## Usage Examples

The following example(s) are provided as guidance:

* [examples/complete](examples/complete/README.md)
