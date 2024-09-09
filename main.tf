provider "aws" {
  region = "eu-central-1"
}


module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.10.0"

  bucket = "my-static-site-bucket-dawdawdawdawd"

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  tags = {
    Name        = "StaticWebsite"
    Environment = "production"
  }
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::my-static-site-bucket-dawdawdawdawd/*"
      },
      {
        Sid    = "GitHubAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::424499126527:role/github-actions-s3-role"
        }
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::my-static-site-bucket-dawdawdawdawd/*"
      }
    ]
  })

}


module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "3.3.0"

  origin = [
    {
      domain_name = "my-static-site-bucket-dawdawdawdawd.s3-website.eu-central-1.amazonaws.com"
      origin_id   = "my-static-site-bucket-dawdawdawdawd"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }
  ]

  default_cache_behavior = {
    target_origin_id       = "my-static-site-bucket-dawdawdawdawd"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    forwarded_values = {
      query_string = false
      cookies = {
        forward = "none"
      }
    }
  }

  viewer_certificate = {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "CloudFrontDistribution"
    Environment = "production"
  }
}
