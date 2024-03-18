resource "aws_ecr_repository" "repository" {
  name = "ecr-${var.projectName}"

}

resource "aws_ecr_repository_policy" "policy-ecr" {
  repository = aws_ecr_repository.policy-ecr.name

  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid       = "AllowPullPushAccess",
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Resource = aws_ecr_repository.repository.arn
      }
    ]
  })
}