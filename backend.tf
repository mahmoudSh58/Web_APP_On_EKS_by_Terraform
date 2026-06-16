terraform {
  backend "s3" {
    bucket       = "nti-tf-state-mahmoudsh"
    key          = "proj01/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true   # S3 native locking — no DynamoDB needed
  }

}