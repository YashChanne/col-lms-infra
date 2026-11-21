resource "aws_db_subnet_group" "db_subnets" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.db_pri_sub_01.id, aws_subnet.db_pri_sub_02.id]

  tags = {
    Name = "db-subnet-group-01"
  }
}

resource "aws_db_instance" "mysql_01" {
  identifier        = "${var.project_name}-mysql"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.db_instance_class
  allocated_storage = 20
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  # AWS generates the password and stores it in Secrets Manager (nothing hardcoded in code)
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  multi_az               = false # single AZ to keep the lab cheap

  backup_retention_period = 0
  skip_final_snapshot     = true

  tags = {
    Name = "mysql-01"
  }
}
