resource "aws_iam_role_policy" "irsa_s3_access" {
  name        = "irsa_s3_access"
  role =    aws_iam_role.irsa_s3_access_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "${local.test_bucket_arn}",
          "${local.test_bucket_arn}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "irsa_s3_access_role" {
  name = "irsa_s3_access_role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Federated": "${module.eks.oidc_provider_arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
            StringEquals: {
            "${module.eks.oidc_provider}:aud": "sts.amazonaws.com",
            "${module.eks.oidc_provider}:sub": "system:serviceaccount:default:s3access"
            }
        }
        }
    ]
  })
}

resource "aws_iam_role_policy" "eks_cluster_read_only" {
  name        = "eks_cluster_read_only"
  role =    aws_iam_role.eks_cluster_read_only_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Effect = "Allow"
        Resource = [
          module.eks.cluster_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "eks_cluster_read_only_role" {
  name = "eks_cluster_read_only_role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_role" "eks_cluster_read_only_role_new" {
  name = "eks_cluster_read_only_role_new"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}