terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "AKIATQPD7DLEUNNPHLWT"
  secret_key = "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"
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bucket"
  acl    = "private"
  provider = aws.us_east_2
}

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
  access_key = "AKIATQPD7DLEUNNPHLWT"
  secret_key = "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"
}

resource "aws_s3_bucket_public_access_block" "test_public_access" {
  bucket = aws_s3_bucket.test_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "test_encryption" {
  bucket = aws_s3_bucket.test_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "bucket_id" {
  value = aws_s3_bucket.test_bucket.id
}
