resource "aws_autoscaling_group" "asg-01" {
  name                      = "${var.project_name}-asg"
  min_size                  = var.asg_min
  max_size                  = var.asg_max
  desired_capacity          = var.asg_desired
  vpc_zone_identifier       = [aws_subnet.app_pri_sub_01.id, aws_subnet.app_pri_sub_02.id]
  target_group_arns         = [aws_lb_target_group.main.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.lt_01.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "app-server"
    propagate_at_launch = true
  }

  # Servers need the NAT gateway ready so they can install nginx
  depends_on = [aws_nat_gateway.nat_01]
}
