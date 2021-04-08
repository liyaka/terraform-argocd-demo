variable "app_aws_account" {
  description = "AWS account"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ops_role" {
  description = "Ops Role"
  type        = string
}

# variable "environment_type" {
#   description = "AWS region"
#   type        = string
#   default     = "dev" # prod, staging, dev
# }


variable "vpc_subnets" {
  description = "Subnets for all VPCs"
  type        = map(any)
  default = {
    vpc_public_subnets  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    vpc_private_subnets = ["10.1.8.0/24", "10.1.9.0/24", "10.1.10.0/24"]

  }
}

variable "vpc_cidr" {
  description = "CIDR Prefix"
  type        = string
  default     = "10.1.0.0/16"
}

# ECR
variable "ecr_principals_readonly_access" {
  description = "Roles with ECR ReadOnly access to ECR"
  type        = list(string)
  default     = ["arn:aws:iam::329054710135:role/liya-ops"]
}

variable "ecr_principals_full_access" {
  description = "Roles with ECR Full access to ECR"
  type        = list(string)
  default     = ["arn:aws:iam::329054710135:role/liya-ops"]
}

variable "ecr_repositories" {
  description = "Subnets for all VPCs"
  type        = list(string)
  default     = ["dummy-app"]
}


# EKS
variable "eks_allowed_users" {
  description = "Allowed users for EKS"
  type        = list(any)
  default     = []
}

variable "eks_allowed_roles" {
  description = "Allowed roles for EKS"
  type        = list(any)
  default     = []
  # default = [
  #   {
  #     rolearn  = "arn:aws:iam::329054710135:role/liya-ops"
  #     username = "ops"
  #     groups   = ["system:masters"]
  #   }
  # ]
}

variable "eks_cluster" {
  description = "EKS Clusters"
  type        = map(any)
  default = {
    eks = {
      cluster_version           = "1.18"
      eks_tags                  = {}
      cluster_enabled_log_types = [] # TODO
      worker_group_name         = "worker-t3m"
      worker_instance_type      = "t3.medium"
      asg_desired_capacity      = 1
      asg_max_size              = 5
      asg_min_size              = 1
      cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
    }
  }
}
