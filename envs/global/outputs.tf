output "root_encrypt_key_id" {
  description = "EBS root volume encrytpion key ID"
  value       = aws_kms_key.root_encrypt.key_id
}

output "root_encrypt_arn" {
  description = "EBS root volume encrytpion key ARN"
  value       = aws_kms_key.root_encrypt.arn
}

output "tf_state_bucket_key_id" {
  description = "Terraform state s3 bucket encryption key ID"
  value       = aws_kms_key.tf_state_bucket.key_id
}

output "tf_state_bucket_key_arn" {
  description = "Terraform state s3 bucket encryption key ARN"
  value       = aws_kms_key.tf_state_bucket.arn
}

output "tf_state_bucket_arn" {
  description = "Terraform state s3 bucket ARN"
  value       = aws_s3_bucket.tf_state.arn
}