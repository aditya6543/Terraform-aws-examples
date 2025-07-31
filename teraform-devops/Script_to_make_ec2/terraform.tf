#download aws provider for terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {                 #creates a backup file on aws dynamo db and s3 to create a remote .tf file to manage conflicts and remote stage code to this is in another folder named terraform-remote
    bucket = "adiremote-test"
    key = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "remote-infra"
    
  }
}
