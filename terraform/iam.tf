resource "aws_iam_user" "dev_view" {
  name = "bedrock-dev-view"
  tags = { Name = "bedrock-dev-view" }
}

resource "aws_iam_user_login_profile" "dev_view" {
  user                    = aws_iam_user.dev_view.name
  password_reset_required = true
}

resource "aws_iam_access_key" "dev_view" {
  user = aws_iam_user.dev_view.name
}

resource "aws_iam_user_policy_attachment" "dev_view_readonly" {
  user       = aws_iam_user.dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_policy" "dev_view_s3" {
  name = "project-bedrock-dev-view-s3-policy"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Effect = "Allow", Action = ["s3:PutObject"], Resource = "${aws_s3_bucket.assets.arn}/*" }]
  })
}

resource "aws_iam_user_policy_attachment" "dev_view_s3" {
  user       = aws_iam_user.dev_view.name
  policy_arn = aws_iam_policy.dev_view_s3.arn
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapUsers = yamlencode([{
      userarn  = aws_iam_user.dev_view.arn
      username = "bedrock-dev-view"
      groups   = ["bedrock-dev-view-group"]
    }])
  }
  force      = true
  depends_on = [aws_eks_cluster.main]
}
