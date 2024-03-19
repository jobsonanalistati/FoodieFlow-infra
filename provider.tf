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
data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster_auth.token
  }
}