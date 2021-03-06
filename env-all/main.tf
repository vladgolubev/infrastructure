provider "aws" {
  region  = "eu-central-1"
  version = "~> 2.3"
  profile = "vlad"
}

provider "aws" {
  region  = "us-east-1"
  alias   = "us_east_1"
  version = "~> 2.3"
  profile = "vlad"
}

resource "aws_s3_bucket" "vladholubiev_tf_state" {
  bucket   = "vladholubiev-tf-state"
  provider = aws

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Terraform = true
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "vladholubiev_sls" {
  bucket   = "vladholubiev-serverless"
  region   = "us-east-1"
  provider = aws.us_east_1

  tags = {
    Terraform = true
  }

  versioning {
    enabled = true
  }
}

terraform {
  backend "s3" {
    acl     = "private"
    bucket  = "vladholubiev-tf-state"
    key     = "env-all/main.tfstate"
    encrypt = "true"
    region  = "eu-central-1"
    profile = "vlad"
  }
}

