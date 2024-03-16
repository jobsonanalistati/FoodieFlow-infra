module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.5"

  cluster_name                   = "cluster-eks-${var.projectName}"
  cluster_version                = "1.29"
  cluster_endpoint_public_access = true
  subnet_ids                     = module.vpc.public_subnets
  vpc_id                         = module.vpc.vpc_id

  eks_managed_node_groups = {
    initial = {
      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 5
      desired_size = 2
    }
  }
}
