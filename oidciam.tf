resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [

    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

resource "aws_iam_role" "github_oidc_role" {
  name = "github-actions-s3-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:DarkAngelUiversal/testTF:*"
          },
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "github-s3-access-policy"
  description = "Policy for GitHub Actions to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::my-static-site-bucket-dawdawdawdawd/*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
