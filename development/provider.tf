provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

terraform {
  required_providers {
     aws = {
      source  = "hashicorp/aws"
      # version = "~> 4.0"
    }
    # aws = {
    #   source = "hashicorp/aws"
    # }
  }

  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "terraform-aws-for-ec2"
    key    = "dev/cicd/terraform.tfstate"
    region = "us-east-1" 
  
    # For State Locking
    # dynamodb_table = "dev-project1-vpc"    
  }  
}
