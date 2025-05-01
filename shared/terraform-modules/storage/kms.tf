resource "aws_kms_key" "s3_timemachine_primary" {
  provider            = aws.primary
  description         = "KMS key for S3 primary backup encryption"
  enable_key_rotation = true
}

resource "aws_kms_alias" "s3_timemachine_primary" {
  provider      = aws.primary
  name          = "alias/s3-timemachine-primary"
  target_key_id = aws_kms_key.s3_timemachine_primary.id
}

resource "aws_kms_key" "s3_timemachine_secondary" {
  provider            = aws.secondary
  description         = "KMS key for S3 secondary backup encryption"
  enable_key_rotation = true
}

resource "aws_kms_alias" "s3_timemachine_secondary" {
  provider      = aws.secondary
  name          = "alias/s3-timemachine-secondary"
  target_key_id = aws_kms_key.s3_timemachine_secondary.id
}
