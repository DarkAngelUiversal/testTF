resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-bucket-dawdawdawdawd"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "TerraformStateBucket"
    Environment = "production"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock-table-dawdawdawdawd"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "TerraformLockTable"
    Environment = "production"
  }
}
