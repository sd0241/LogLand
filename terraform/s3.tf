resource "aws_s3_bucket" "ssac_s3_bucket" {
  bucket = "ssac-bucket"
  acl    = "private"

  force_destroy = true

  versioning {
    enabled = false
  }


  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }


  lifecycle_rule {
    id      = "DisableBucketKeys"
    enabled = true
    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }


  tags = {
    Name = "${var.name}-s3-bucket"
  }
}


resource "aws_iam_role_policy_attachment" "s3_access_policy_attachment" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.s3_access_role.name
}

# resource "aws_iam_instance_profile" "instance_profile" {
#   name = "s3-instance-profile"

#   role = aws_iam_role.s3_access_role.name
# }


# resource "aws_s3_bucket" "audit-bucket" {
#   bucket = "${var.name}-cloudtrail-logs"
#   acl    = "private"
# }