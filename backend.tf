terraform {
  backend "s3" {
    bucket = "akash-terraform-state-demo"
    key    = "terraform/test/terraform.tfstate"
    region = "us-east-1"
  }
}