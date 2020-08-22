provider "aws" {
  region  = "us-east-1"
  version = "~> 3.0"
  profile = "vlad"
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "VladHolubiev"

    workspaces {
      name = "website"
    }
  }
}
