provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  assume_role {
    # TODO
    role_arn = "arn:aws:iam::329054710135:role/liya-ops"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "liya-terraform-state"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "liya-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
