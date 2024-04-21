resource "aws_iam_role_policy" "irsa_s3_access" {
  name = "irsa_s3_access"
  role = aws_iam_role.irsa_s3_access_role.id

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
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${module.eks.oidc_provider_arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          StringEquals : {
            "${module.eks.oidc_provider}:aud" : "sts.amazonaws.com",
            "${module.eks.oidc_provider}:sub" : "system:serviceaccount:default:s3access"
          }
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "eks_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_iam_policy" "eks_cluster_list_describe" {
  name        = "eks_cluster_list_describe"
  description = "Policy to describe and list EKS clister"

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

resource "aws_iam_role" "eks_cluster_secure_api_read_only_role" {
  name               = "eks_cluster_secure_api_read_only_role"
  assume_role_policy = data.aws_iam_policy_document.eks_role_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_secure_api_read_only_attach" {
  role       = aws_iam_role.eks_cluster_secure_api_read_only_role.name
  policy_arn = aws_iam_policy.eks_cluster_list_describe.arn
}

resource "aws_iam_role" "eks_cluster_open_api_edit_role" {
  name               = "eks_cluster_open_api_edit_role"
  assume_role_policy = data.aws_iam_policy_document.eks_role_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_open_api_edit_attach" {
  role       = aws_iam_role.eks_cluster_open_api_edit_role.name
  policy_arn = aws_iam_policy.eks_cluster_list_describe.arn
}