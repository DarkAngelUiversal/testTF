terraform {
  backend "s3" {
    bucket         = aws_s3_bucket.terraform_state.bucket
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = aws_dynamodb_table.terraform_lock.name
  }
}
