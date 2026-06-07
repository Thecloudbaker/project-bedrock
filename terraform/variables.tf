variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "student_id" {
  type = string
}

variable "project_tag" {
  type    = string
  default = "karatu-2025-capstone"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "eks_cluster_version" {
  type    = string
  default = "1.34"
}

variable "node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 3
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "mysql_db_name" {
  type    = string
  default = "catalog"
}

variable "mysql_username" {
  type    = string
  default = "catalog_user"
}

variable "postgres_db_name" {
  type    = string
  default = "orders"
}

variable "postgres_username" {
  type    = string
  default = "orders_user"
}
# test
