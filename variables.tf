variable "aws_default_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "foodway_db_user" {
  description = "Database username for the application"
  type        = string
}

variable "foodway_db_password" {
  description = "Database password for the application"
  type        = string
}

variable "eks_cluster_name" {
  description = "Nome do EKS Cluster"
  type        = string
  default     = "foodway_eks_cluster_j5431"
}

variable "foodway_api_image" {
  description = "Imagem do container para a API Foodway"
  type        = string

}