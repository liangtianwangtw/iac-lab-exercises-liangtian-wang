# create a s3 bucket for the terraform state
resource "aws_s3_bucket" "iac-lab-liangtian-wang-tfstate" {
  bucket = "${var.prefix}-tfstate"
  force_destroy = true

  tags = {
    Name        = "iac-lab-liangtian-wang-tfstate"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "iac-lab-liangtian-wang-tfstate_versioning" {
    bucket = aws_s3_bucket.iac-lab-liangtian-wang-tfstate.bucket
    
    versioning_configuration {
    status = "Enabled"
  }
}
