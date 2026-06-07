resource "aws_dynamodb_table" "cart" {
  name         = "project-bedrock-cart"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
  tags = { Name = "project-bedrock-cart" }
}

resource "aws_iam_role" "cart_service" {
  name = "project-bedrock-cart-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.eks.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:retail-app:cart"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "cart_dynamodb" {
  name = "project-bedrock-cart-dynamodb-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:DeleteItem", "dynamodb:Query", "dynamodb:Scan"]
      Resource = aws_dynamodb_table.cart.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cart_dynamodb" {
  policy_arn = aws_iam_policy.cart_dynamodb.arn
  role       = aws_iam_role.cart_service.name
}
