variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-2"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  default     = "dev"
  type        = string
}

variable "cluster_name" {
  description = "EKS_cluster_name"
  default     = "secure-microservice-eks"
  type        = string
}

variable "cluster_version" {
  description = "kubernetes version for eks"
  default     = "1.29"
  type        = string
}

variable "node_group_instance_type" {
  description = "EC2 instance type for EKS worker node"
  default     = "t2.medium"
  type        = string
}
