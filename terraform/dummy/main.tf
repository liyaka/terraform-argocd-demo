
locals {
  project = "liya"
  # Common tags to be assigned to all resources
  common_tags = {
    Terraform   = "true"
    Environment = var.environment
  }

  name_prefix = "${local.project}-${var.environment}" # e.g: liya-prod
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

# terraform {
#   backend "s3" {
#     role_arn       = "arn:aws:iam::329054710135:role/liya-ops"
#     encrypt        = true
#     bucket         = "liya-terraform-state"
#     key            = "terraform.tfstate"
#     region         = "eu-west-1"
#     dynamodb_table = "liya-terraform-lock"
#   }
# }
