
# account_name    = "liya@tikalk.com"
app_aws_account = "329054710135"
aws_profile     = "tikal"
aws_region      = "eu-west-1"

ops_role = "arn:aws:iam::329054710135:role/liya-ops"

environment = "prod"

# services = ["dummy-app"]

eks_allowed_users = [
  {
    userarn  = "arn:aws:iam::329054710135:user/liya@tikalk.com"
    username = "liya"
    groups   = ["system:masters"]
  },
]
eks_allowed_roles = [
  {
    rolearn  = "arn:aws:iam::329054710135:role/liya-ops"
    username = "ops"
    groups   = ["system:masters"]
  }
]
