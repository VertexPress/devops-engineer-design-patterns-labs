terraform {
  backend "s3" {
    bucket         = "vertexpress-tfstate"
    key            = "prod/network/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true                 # S3-native locking (dynamodb_table is deprecated)
    encrypt        = true
  }
}
