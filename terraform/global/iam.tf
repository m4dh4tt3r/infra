data "aws_iam_policy_document" "tf_state" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.tf_state.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["${aws_s3_bucket.tf_state.arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/terraform-state-lock"]
  }
}

resource "aws_iam_policy" "tf_state" {
  name        = "tf_state"
  description = "Terraform state permissions"
  policy      = data.aws_iam_policy_document.tf_state.json
}

resource "aws_iam_policy_attachment" "tf_state" {
  name       = "tf_state"
  groups     = [aws_iam_group.Admin.name]
  policy_arn = aws_iam_policy.tf_state.arn
}