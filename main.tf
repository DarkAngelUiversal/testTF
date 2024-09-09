module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.10.0"

  bucket = "my-static-site-bucket-dawdawdawdawd"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "StaticWebsite"
    Environment = "production"
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = module.s3_bucket.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${module.s3_bucket.bucket_arn}/*"
      }
    ]
  })
}

module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "3.3.0"

  origin = {
    domain_name = module.s3_bucket.bucket_regional_domain_name
    origin_id   = "S3-my-static-site-bucket-dawdawdawdawd"

    s3_origin_config = {
      origin_access_identity = module.cloudfront_origin_access_identity.cloudfront_access_identity_path
    }
  }

  default_cache_behavior = {
    target_origin_id       = "S3-my-static-site-bucket-dawdawdawdawd"
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

  restrictions = {
    geo_restriction = {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "CloudFrontDistribution"
    Environment = "production"
  }
}

module "cloudfront_origin_access_identity" {
  source  = "terraform-aws-modules/cloudfront-origin-access-identity/aws"
  version = "1.2.0"
}
