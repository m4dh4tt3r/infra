data "aws_iam_policy_document" "replication_role_policy" {
  provider = aws.primary
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "replication" {
  provider           = aws.primary
  name               = "s3-timemachine-replication"
  assume_role_policy = data.aws_iam_policy_document.replication_role_policy.json
}

data "aws_iam_policy_document" "replication" {
  provider = aws.primary
  statement {
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:GetObjectVersionForReplication",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.timemachine_primary.id}/*",
      "arn:aws:s3:::${aws_s3_bucket.timemachine_secondary.id}/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = ["s3:ListBucket"]

    resources = ["arn:aws:s3:::${aws_s3_bucket.timemachine_primary.id}/*"]
  }
}

resource "aws_iam_policy" "replication" {
  provider    = aws.primary
  name        = "s3-replication-policy"
  description = "Time Machine s3 replication policy"
  policy      = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_role_policy_attachment" "replication" {
  provider   = aws.primary
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}
