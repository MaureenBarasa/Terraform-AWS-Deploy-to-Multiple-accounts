terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }
  }
  backend "s3" {
    bucket = "maureen-terraform-st-bckt"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  alias = "source"
  access_key = var.AWS_ACCESS_KEY_PROD #the IAM Access Key
  secret_key = var.AWS_SECRET_KEY_PROD #the IAM Secret key
  region     = var.AWS_REGION_PROD     #the AWS Region
  skip_credentials_validation = true
  skip_requesting_account_id = true

}

provider "aws" {
  alias = "destination-dev"
  region     = var.AWS_REGION_DEV     #the AWS Region
  assume_role {
    role_arn  = "arn:aws:iam::******************:role/Cross-Account-Staging" #The prod/staging/dev cross account role created
  }
}

module "S3-Dev" {
  source = "./Modules/S3-Dev"
  providers = {
    aws = aws.destination-dev
  }
}
