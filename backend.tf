terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-dawdawdawdawd"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock-table-dawdawdawdawd"
  }
}
