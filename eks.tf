module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8"

  cluster_name                             = "cluster-eks-${var.projectName}-app"
  cluster_version                          = "1.29"
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  subnet_ids                               = module.vpc.public_subnets
  vpc_id                                   = module.vpc.vpc_id

  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  eks_managed_node_groups = {
    initial = {
      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 5
      desired_size = 2

      # Configurando a política de segurança para permitir tráfego na porta 8080 
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
    }
  }
}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_metrics_server = true

  depends_on = [
    module.eks
  ]
}

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

  depends_on = [
    module.eks,
    module.eks_blueprints_addons
  ]
}


resource "helm_release" "secrets-provider-aws" {
  name       = "secrets-provider-aws"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"

  depends_on = [
    module.eks,
    module.eks_blueprints_addons,
    helm_release.csi-secrets-store
  ]
}

resource "kubernetes_namespace_v1" "foodieflow_namespace_app" {
  metadata {
    name = "foodieflow_namespace_app"
  }

  depends_on = [
    module.eks
  ]
}

resource "aws_iam_role" "serviceaccount_role" {
  name = "aws-iam-serviceaccount-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider}:aud" : "sts.amazonaws.com",
            "${module.eks.oidc_provider}:sub" : "system:serviceaccount:${var.app_namespace}:${var.serviceaccount_name}"
          }
        }
      }
    ]
  })
}

#garantir provider
data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster_auth.token
  }
}
