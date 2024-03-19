# Definindo a política IAM necessária para o serviço EKS e VPC CNI
resource "aws_iam_policy" "eks_cni_policy" {
  name        = "eks-cni-policy"
  description = "IAM policy for Amazon EKS CNI"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ec2:DescribeNetworkInterfaces",
        Resource = "*"
      }
    ]
  })
}

# Associando a política ao papel IAM
resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  role       = aws_iam_role.serviceaccount_role.name
  policy_arn = aws_iam_policy.eks_cni_policy.arn
}

# Definindo o cluster EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8"

  cluster_name                             = "cluster-eks-${var.projectName}"
  cluster_version                          = "1.29"
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  subnet_ids                               = module.vpc.public_subnets
  vpc_id                                   = module.vpc.vpc_id

  # Adicionando addons ao cluster EKS
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  # Definindo o grupo de nós gerenciados EKS
  eks_managed_node_groups = {
    initial = {
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 5
      desired_size = 2


      additional_security_group_rules = [
        {
          description       = "Allow incoming traffic on port 8080"
          from_port         = 8080
          to_port           = 8080
          protocol          = "tcp"
          cidr_blocks       = ["0.0.0.0/0"]
          ipv6_cidr_blocks  = []
          prefix_list_ids   = []
          security_group_id = null
          self              = false
        }
      ]

      # Adicionando a política do Amazon EKS CNI
      additional_policies = [aws_iam_policy.eks_cni_policy.arn]
    }
  }
}

# Módulo para adicionar addons ao cluster EKS
module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_metrics_server = true

  depends_on = [module.eks]
}

# Recurso Helm para implantar o driver de armazenamento CSI Secrets Store
resource "helm_release" "csi-secrets-store" {
  name       = "csi-secrets-store"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"

  set {
    name  = "syncSecret.enabled"
    value = "true"
  }
  set {
    name  = "enableSecretRotation"
    value = "true"
  }

  depends_on = [module.eks, module.eks_blueprints_addons]
}

# Recurso Helm para implantar o provedor AWS Secrets Store CSI Driver
resource "helm_release" "secrets-provider-aws" {
  name       = "secrets-provider-aws"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"

  depends_on = [module.eks, module.eks_blueprints_addons, helm_release.csi-secrets-store]
}

# Recurso Kubernetes para criar um namespace
resource "kubernetes_namespace_v1" "foodieflownamespace" {
  metadata {
    name = "foodieflownamespace"
  }

  depends_on = [module.eks]
}

# Recurso IAM para definir o papel de serviço
resource "aws_iam_role" "serviceaccount_role" {
  name = "aws-iam-serviceaccount-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Federated = module.eks.oidc_provider_arn },
        Action    = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider}:aud" = "sts.amazonaws.com",
            "${module.eks.oidc_provider}:sub" = "system:serviceaccount:${var.app_namespace}:${var.serviceaccount_name}"
          }
        }
      }
    ]
  })
}

# Recurso para anexar a política do Amazon EKS CNI ao papel de serviço
resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  role       = aws_iam_role.serviceaccount_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
