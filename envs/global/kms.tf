resource "aws_kms_key" "root_encrypt" {
  description  = "Encryption key for EBS root volume encryption"
  multi_region = true
}

resource "aws_kms_alias" "root_encrypt" {
  name          = "alias/ami_root_encrypt"
  target_key_id = aws_kms_key.root_encrypt.key_id
}

resource "aws_kms_key" "tf_state_bucket" {
  description  = "Encryption key for terraform state bucket objects"
  multi_region = true
}

resource "aws_kms_alias" "tf_state_bucket" {
  name          = "alias/tf_state_bucket"
  target_key_id = aws_kms_key.root_encrypt.key_id
}
