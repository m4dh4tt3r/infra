output "s3_timemachine_primary_name" {
  value = aws_s3_bucket.timemachine_primary.id
}

output "s3_timemachine_secondary_name" {
  value = aws_s3_bucket.timemachine_secondary.id
}

output "kms_primary_key_arn" {
  value = aws_kms_key.s3_timemachine_primary.arn
}

output "kms_secondary_key_arn" {
  value = aws_kms_key.s3_timemachine_secondary.arn
}
