terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41"
    }
  }

  backend "s3" {
    bucket = "terraform-foodieflow-db"
    key    = "api/terraform.tfstate"
    region = "us-east-1"
  }

  required_version = ">= 1.3"
}

provider "aws" {
  region = var.regionDefault
}

#garantir provider