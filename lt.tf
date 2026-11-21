data "aws_ssm_parameter" "ami" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

resource "aws_launch_template" "lt_01" {
  name_prefix   = "${var.project_name}-lt-"
  instance_type = var.instance_type
  image_id      = data.aws_ssm_parameter.ami.value

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_sg.id]
  }

  # Installs nginx and shows which server answered (proves load balancing works)
  user_data = base64encode(<<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    echo "<h1>col-lms app server: $(hostname)</h1>" > /var/www/html/index.html
    systemctl enable --now nginx
  EOT
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app-server"
    }
  }

  tags = {
    Name = "lt-project-01"
  }
}
