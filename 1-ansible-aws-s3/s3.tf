terraform {
  backend "s3" {
    bucket = "mkbucket-ansible"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1" # Change the region as per your requirement
}

resource "random_shuffle" "bucket_suffix" {
  input = ["warrior", "maeludo", "yoel", "maeyoel", "tht", "deco", "terra", "terraform"]
  result_count = 1
}

resource "aws_s3_bucket" "mk_bucket" {
  bucket = "mkbucket-${random_shuffle.bucket_suffix.result[0]}" # Randomly selected bucket name suffix
}

resource "aws_s3_bucket_lifecycle_configuration" "mk_bucket_lifecycle" {
  rule {
    id      = "abort-incomplete-multipart-upload-rule"
    status  = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  bucket = aws_s3_bucket.mk_bucket.id
}

resource "aws_s3_bucket_versioning" "mk_bucket_versioning" {
  bucket = aws_s3_bucket.mk_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
