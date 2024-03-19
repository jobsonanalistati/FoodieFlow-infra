resource "aws_iam_policy" "secretsmanager_getsecretvalue" {
  name        = "secretsmanager_getsecretvalue"
  description = "Permite a ação secretsmanager:GetSecretValue"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "secretsmanager:GetSecretValue",
        Resource = "${data.aws_secretsmanager_secret.foodieFlow_secrets.arn}"
      }
    ]
  })
}


resource "aws_iam_role" "eks_role" {
  name = "eks_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy_to_role" {
  role       = aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.secretsmanager_getsecretvalue.arn
}


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

      iam_role_id = aws_iam_role.eks_role.id

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