resource "aws_s3_bucket" "remote_s3" {
  bucket = "adiremote-test"

  tags = {
    Name        = "adiremote-test"
  
  }
}