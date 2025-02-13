/*resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-private-bucket"
  acl    = "private"


  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}*/



resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "mybucket5" {
  bucket = "mybucket-test5"
  provider = aws.us_east_1
}
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
  access_key = "AKIATQPD7DLEUNNPHLWT"
  secret_key = "UfCpwmnLQfzMYeMS2yPwZs+bejMjd2RSrKYUlR+z"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.mybucket1.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket5.id


  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/*resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}*/

