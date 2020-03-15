resource "aws_s3_bucket" "vladholubiev_com" {
  bucket = var.domain
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  lifecycle {
    prevent_destroy       = true
    create_before_destroy = true
  }

  tags = {
    Terraform   = true
    Environment = var.env
  }

  lifecycle_rule {
    id      = "tmp"
    prefix  = "tmp/"
    enabled = true

    expiration {
      days = 3
    }
  }
}

resource "aws_s3_bucket" "blog_vladholubiev_com" {
  bucket = "blog.${var.domain}"
  acl    = "public-read"

  website {
    redirect_all_requests_to = "https://medium.com/@vladholubiev"
  }

  tags = {
    Terraform   = true
    Environment = var.env
  }
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.vladholubiev_com.id
  policy = data.aws_iam_policy_document.allow_public_read.json
}

data "aws_iam_policy_document" "allow_public_read" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.vladholubiev_com.bucket}/*",
    ]
  }
}
