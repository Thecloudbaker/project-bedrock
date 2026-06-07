output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "region" {
  value = var.aws_region
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}

output "mysql_endpoint" {
  value = aws_db_instance.mysql.address
}

output "postgres_endpoint" {
  value = aws_db_instance.postgres.address
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.cart.name
}

output "cart_service_role_arn" {
  value = aws_iam_role.cart_service.arn
}

output "dev_view_access_key_id" {
  value     = aws_iam_access_key.dev_view.id
  sensitive = true
}

output "dev_view_secret_access_key" {
  value     = aws_iam_access_key.dev_view.secret
  sensitive = true
}

output "dev_view_console_password" {
  value     = aws_iam_user_login_profile.dev_view.password
  sensitive = true
}

output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name project-bedrock-cluster"
}
