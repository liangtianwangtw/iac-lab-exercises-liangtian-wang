terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40.0"
    }
  }

  backend "s3" {
    bucket = "liangtian-wang-iac-lab-tfstate"
    key    = "state"
    region = "ap-southeast-2"

    dynamodb_table = "liangtian-wang-iac-lab-tfstate-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
  default_tags {
        tags = {
          ManagedBy    = "Terraform"
          Project      = var.prefix
          Environment  = "Dev"
    }
  }
}

