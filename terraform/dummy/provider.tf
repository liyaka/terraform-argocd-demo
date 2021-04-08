terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.32.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.12"
    }
    # random = {
    #   version = "~> 2.1"
    # }
    #
    # local = {
    #   version = "~> 1.2"
    # }
    #
    # null = {
    #   version = "~> 2.1"
    # }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.1"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  assume_role {
    role_arn = var.ops_role
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}
