provider "aws" {
  # Assumes you have a CLI profile named terraform setup already
  profile = "terraform"
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}