resource "aws_lb" "alb-project-01" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.col_lms_pub_sub_01.id, aws_subnet.col_lms_pub_sub_02.id]

  tags = {
    Name = "alb-01"
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.project_name}-tg"
  port        = var.http_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.col_lms_vpc.id
  target_type = "instance" # EC2 instances from the Auto Scaling Group

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "alb-tg"
  }
}

resource "aws_lb_listener" "HTTP" {
  load_balancer_arn = aws_lb.alb-project-01.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
