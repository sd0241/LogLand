terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.14.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }
  }

  required_version = "~> 1.3"
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "EKS"
    }
  }
}

locals {
  api_version = "client.authentication.k8s.io/v1beta1"
  args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  command     = "aws"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = local.api_version
    args        = local.args
    command     = local.command
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = local.api_version
      args        = local.args
      command     = local.command
    }
  }
}
