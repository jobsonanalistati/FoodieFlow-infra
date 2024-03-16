resource "aws_lb" "FoodieFlowAlb" {
  name               = "alb-${var.projectName}"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.FoodieFlowAlb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group.arn
  }
}

resource "aws_lb_target_group" "group" {
  name     = "alb-group-${var.projectName}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}
