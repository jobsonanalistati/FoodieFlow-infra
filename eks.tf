module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.5"

  cluster_name                             = "cluster-eks-${var.projectName}"
  cluster_version                          = "1.29"
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  subnet_ids                               = module.vpc.public_subnets
  vpc_id                                   = module.vpc.vpc_id

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

################################################################################
# Helm packages
################################################################################

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

################################################################################
# Namespaces
################################################################################

# Declare o(s) namespaces caso deseje que o Terraform exclua os Services, 
# e consequentemente os Load Balancers atrelados a eles, ao fazer "terraform destroy"

resource "kubernetes_namespace_v1" "eks_namespace" {
  metadata {
    name = var.app_namespace
  }

  depends_on = [
    module.eks
  ]
}

################################################################################
# Supporting Resources
################################################################################

# Configuração de uma conta de serviço do Kubernetes para assumir um perfil do IAM
# Todos os Pods configurados para usar a conta de serviço podem então acessar quaisquer AWS service (Serviço da AWS) para os quais a função tenha permissões de acesso.
# https://docs.aws.amazon.com/pt_br/eks/latest/userguide/associate-service-account-role.html

resource "aws_iam_role" "serviceaccount_role" {
  name = "aws-iam-serviceaccount-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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
      },
    ]
  })

}