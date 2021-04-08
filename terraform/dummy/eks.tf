# ---------------------------------------------------------------------------------------------------------------------
# Data from eks module for k8s provider. see ./providers.tf
# ---------------------------------------------------------------------------------------------------------------------
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

# ---------------------------------------------------------------------------------------------------------------------
# Resources for EKS
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_kms_key" "eks" {
  description             = "KMS key for ${local.name_prefix} cluster"
  deletion_window_in_days = 10

  tags = local.common_tags
}

resource "aws_kms_alias" "eks" {
  name          = "alias/${local.name_prefix}-eks"
  target_key_id = aws_kms_key.eks.id
}

# Security groups for EKS
resource "aws_security_group" "internal-eks" {
  name_prefix = "internal-eks-"
  description = "Internal EKS service access"
  vpc_id      = module.vpc.vpc_id
  ingress {
    self      = true
    from_port = 0
    to_port   = 0
    protocol  = -1
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "Name" = "internal-eks"
    },
    local.common_tags
  )
}

resource "aws_security_group" "ext-to-int-eks" {
  name_prefix = "ext-to-int-eks-"
  description = "External to internal for EKS"
  vpc_id      = module.vpc.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "Name" = "ext-to-int-eks"
    },
    local.common_tags
  )
}

#  per app and per port that is needed
resource "aws_security_group_rule" "allow_ext_access_eks" {
  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "tcp"
  // TODO add securoty groups instead
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ext-to-int-eks.id
}

resource "aws_security_group" "inter-eks" {
  name_prefix = "inter-eks-"
  description = "Inter-service for EKS"
  vpc_id      = module.vpc.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "Name" = "inter-eks"
    },
    local.common_tags
  )
}

# resource "aws_security_group" "worker_group_mgmt" {
#   name_prefix = "worker_group_mgmt"
#   vpc_id      = module.vpc.vpc_id
#
#   ingress {
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"
#
#     cidr_blocks = [
#       "10.0.0.0/8",
#     ]
#   }
#
#   tags = local.common_tags
# }
#
# resource "aws_security_group" "all_worker_mgmt" {
#   name_prefix = "all_worker_management"
#   vpc_id      = module.vpc.vpc_id
#
#   ingress {
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"
#
#     cidr_blocks = [
#       "10.0.0.0/8",
#       "172.16.0.0/12",
#       "192.168.0.0/16",
#     ]
#   }
#
#   tags = local.common_tags
# }

# EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "14.0.0"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]

  cluster_name              = local.name_prefix
  cluster_version           = var.eks_cluster.eks.cluster_version
  map_roles                 = var.eks_allowed_roles
  map_users                 = var.eks_allowed_users
  cluster_enabled_log_types = var.eks_cluster.eks.cluster_enabled_log_types

  enable_irsa      = true
  write_kubeconfig = true
  # config_output_path = "${pathexpand("~/.kube/")}/" # append "/" to end of path

  worker_groups_launch_template = [

    {
      name                          = var.eks_cluster.eks.worker_group_name
      instance_type                 = var.eks_cluster.eks.worker_instance_type
      asg_desired_capacity          = var.eks_cluster.eks.asg_desired_capacity
      asg_max_size                  = var.eks_cluster.eks.asg_max_size
      asg_min_size                  = var.eks_cluster.eks.asg_min_size
      additional_security_group_ids = [aws_security_group.internal-eks.id, aws_security_group.ext-to-int-eks.id, aws_security_group.inter-eks.id]
    },
  ]
  worker_additional_security_group_ids = [aws_security_group.internal-eks.id, aws_security_group.ext-to-int-eks.id, aws_security_group.inter-eks.id]

  tags = merge(
    {
      "Name" = local.name_prefix
    },
    local.common_tags
  )
}

# # ---------------------------------------------------------------------------------------------------------------------
# # k8s namespaces
# # ---------------------------------------------------------------------------------------------------------------------
# resource "kubernetes_namespace" "dev" {
#   metadata {
#     name = "dev"
#   }
# }
# resource "kubernetes_namespace" "prod" {
#   metadata {
#     name = "prod"
#   }
# }
