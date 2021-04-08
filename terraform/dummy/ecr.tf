# ---------------------------------------------------------------------------------------------------------------------
# Resources for ECR
# ---------------------------------------------------------------------------------------------------------------------

# # Security groups for ECR
# resource "aws_security_group" "internal-ecr" {
#   name_prefix = "internal-ecr-"
#   description = "Internal ECR service access"
#   vpc_id      = module.vpc_services.vpc_id
#   ingress {
#     self      = true
#     from_port = 0
#     to_port   = 0
#     protocol  = -1
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   lifecycle {
#     create_before_destroy = true
#   }
#
#   tags = merge(
#     {
#       "Name" = "internal-ecr"
#     },
#     local.common_tags
#   )
# }
#
# resource "aws_security_group" "ext-to-int-ecr" {
#   name_prefix = "ext-to-int-ecr-"
#   description = "External to internal for ECR"
#   vpc_id      = module.vpc_services.vpc_id
#
#   lifecycle {
#     create_before_destroy = true
#   }
#
#   tags = merge(
#     {
#       "Name" = "ext-to-int-ecr"
#     },
#     local.common_tags
#   )
# }
#
# #  per app and per port that is needed
# resource "aws_security_group_rule" "allow_ext_access_ecr" {
#   type      = "ingress"
#   from_port = 0
#   to_port   = 0
#   protocol  = "tcp"
#   // TODO add securoty groups instead
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.ext-to-int-ecr.id
# }
#
# resource "aws_security_group" "inter-ecr" {
#   name_prefix = "inter-ecr-"
#   description = "Inter-service for ecr"
#   vpc_id      = module.vpc_services.vpc_id
#
#   lifecycle {
#     create_before_destroy = true
#   }
#
#   tags = merge(
#     {
#       "Name" = "inter-ecr"
#     },
#     local.common_tags
#   )
# }

# ---------------------------------------------------------------------------------------------------------------------
# ECR
# ---------------------------------------------------------------------------------------------------------------------
module "ecr" {
  source      = "cloudposse/ecr/aws"
  version     = "0.32.2"
  environment = var.environment
  tags        = local.common_tags

  image_names                = var.ecr_repositories
  principals_readonly_access = var.ecr_principals_readonly_access
  principals_full_access     = var.ecr_principals_full_access
  scan_images_on_push        = false
  image_tag_mutability       = "MUTABLE"
  protected_tags             = ["prod"]

}
