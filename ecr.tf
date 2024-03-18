resource "aws_ecr_repository" "repository" {
  name = "ecr-${var.projectName}"

}