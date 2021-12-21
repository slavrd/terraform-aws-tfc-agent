terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 3.8"

    }
  }
}