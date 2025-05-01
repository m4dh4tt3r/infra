resource "aws_s3_bucket" "timemachine_primary" {
  provider = aws.primary
  bucket   = "timemachine-backup-primary"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_kms_primary" {
  bucket = aws_s3_bucket.timemachine_primary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_timemachine_primary.arn
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_primary" {
  provider = aws.primary
  bucket   = aws_s3_bucket.timemachine_primary.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_primary" {
  provider                = aws.primary
  bucket                  = aws_s3_bucket.timemachine_primary.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "backup_lifecycle_primary" {
  provider = aws.primary
  bucket   = aws_s3_bucket.timemachine_primary.id

  rule {
    id     = "delete-old-backups"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket" "timemachine_secondary" {
  provider = aws.secondary
  bucket   = "timemachine-backup-secondary"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_kms_secondary" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.timemachine_secondary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_timemachine_secondary.arn
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_secondary" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.timemachine_secondary.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_secondary" {
  provider                = aws.secondary
  bucket                  = aws_s3_bucket.timemachine_secondary.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "backup_lifecycle_secondary" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.timemachine_secondary.id

  rule {
    id     = "delete-old-backups"
    status = "Enabled"

    expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "timemachine" {
  provider = aws.primary
  bucket   = aws_s3_bucket.timemachine_primary.id
  role     = aws_iam_role.replication.arn

  rule {
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.timemachine_secondary.arn
      storage_class = "STANDARD"
    }
  }
}