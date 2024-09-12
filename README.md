cd state_bucket

terraform init

terraform apply

cd

terraform init

terraform apply

aws s3 sync ./website s3://my-static-site-bucket-dawdawdawdawd --delete or commit


open  http://my-static-site-bucket-dawdawdawdawd.s3-website.eu-central-1.amazonaws.com/
