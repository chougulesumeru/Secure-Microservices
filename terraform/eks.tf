# --------vpc for eks cluster ------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  #spread across 2 availability zones for high availibity
  azs             = ["us-east-2a", "us-east-2b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  # NAT gateway allows to access private subnet thorugh the internate
  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# ---------------EKS cluster ------------------------

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~>20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  #place control plane in private subnet
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # enable private endpoint - api server not exposed to internate
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # eks manages node groups - AWS manages the EC2 instance
  eks_managed_node_groups = {
    general = {
      min_size       = 1
      max_size       = 2
      desired_size   = 2
      instance_types = var.node_group_instance_type
      subnet_ids     = module.vpc.private_subnets
    }
  }

  tags = {
    name        = "${var.cluster_name}"
    Environment = var.environment
  }
}


# --------KMS key for secret ecryption--------------

resource "aws_kms_key" "eks" {
  description             = "EKS secret encryption key"
  deletion_window_in_days = 2
  enable_key_rotation     = true
}
