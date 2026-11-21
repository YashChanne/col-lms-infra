# Load balancer: open to the internet on HTTP/HTTPS
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP and HTTPS from internet to ALB"
  vpc_id      = aws_vpc.col_lms_vpc.id

  ingress {
    description = "HTTP"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]
  }

  ingress {
    description = "HTTPS"
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_traffic]
  }

  tags = {
    Name = "alb-sg-01"
  }
}

# App servers: only the ALB can reach them (no SSH, no direct internet access)
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-app-sg"
  description = "Allow HTTP only from the ALB"
  vpc_id      = aws_vpc.col_lms_vpc.id

  ingress {
    description     = "HTTP from ALB only"
    from_port       = var.http_port
    to_port         = var.http_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_traffic]
  }

  tags = {
    Name = "app-sg-01"
  }
}

# Database: only the app servers can reach MySQL
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow MySQL only from app servers"
  vpc_id      = aws_vpc.col_lms_vpc.id

  ingress {
    description     = "MySQL from app tier only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  tags = {
    Name = "db-sg-01"
  }
}
