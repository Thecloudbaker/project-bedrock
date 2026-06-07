resource "aws_db_subnet_group" "main" {
  name       = "project-bedrock-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags       = { Name = "project-bedrock-db-subnet-group" }
}

resource "aws_security_group" "rds" {
  name        = "project-bedrock-rds-sg"
  description = "Allow database traffic from EKS nodes only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "project-bedrock-rds-sg" }
}

resource "random_password" "mysql" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "postgres" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "mysql" {
  name                    = "project-bedrock/mysql-credentials"
  recovery_window_in_days = 0
  tags                    = { Name = "project-bedrock-mysql-secret" }
}

resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id = aws_secretsmanager_secret.mysql.id
  secret_string = jsonencode({
    username = var.mysql_username
    password = random_password.mysql.result
    host     = aws_db_instance.mysql.address
    port     = 3306
    dbname   = var.mysql_db_name
  })
}

resource "aws_secretsmanager_secret" "postgres" {
  name                    = "project-bedrock/postgres-credentials"
  recovery_window_in_days = 0
  tags                    = { Name = "project-bedrock-postgres-secret" }
}

resource "aws_secretsmanager_secret_version" "postgres" {
  secret_id = aws_secretsmanager_secret.postgres.id
  secret_string = jsonencode({
    username = var.postgres_username
    password = random_password.postgres.result
    host     = aws_db_instance.postgres.address
    port     = 5432
    dbname   = var.postgres_db_name
  })
}

resource "aws_db_instance" "mysql" {
  identifier             = "project-bedrock-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  storage_type           = "gp2"
  storage_encrypted      = true
  db_name                = var.mysql_db_name
  username               = var.mysql_username
  password               = random_password.mysql.result
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  tags                   = { Name = "project-bedrock-mysql" }
}

resource "aws_db_instance" "postgres" {
  identifier             = "project-bedrock-postgres"
  engine                 = "postgres"
  engine_version         = "15.7"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  storage_type           = "gp2"
  storage_encrypted      = true
  db_name                = var.postgres_db_name
  username               = var.postgres_username
  password               = random_password.postgres.result
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  tags                   = { Name = "project-bedrock-postgres" }
}
