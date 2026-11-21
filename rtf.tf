# ---------- Public route table: internet via Internet Gateway ----------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.col_lms_vpc.id

  route {
    cidr_block = var.all_traffic
    gateway_id = aws_internet_gateway.col_igw.id
  }

  tags = {
    Name = "public-rt-01"
  }
}

resource "aws_route_table_association" "pub_assoc_01" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.col_lms_pub_sub_01.id
}

resource "aws_route_table_association" "pub_assoc_02" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.col_lms_pub_sub_02.id
}

# ---------- Private route table (app tier): outbound only via NAT ----------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.col_lms_vpc.id

  route {
    cidr_block     = var.all_traffic
    nat_gateway_id = aws_nat_gateway.nat_01.id
  }

  tags = {
    Name = "private-rt-01"
  }
}

resource "aws_route_table_association" "app_assoc_01" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.app_pri_sub_01.id
}

resource "aws_route_table_association" "app_assoc_02" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.app_pri_sub_02.id
}

# ---------- DB route table: local VPC traffic only, no internet ----------
resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.col_lms_vpc.id

  tags = {
    Name = "db-rt-01"
  }
}

resource "aws_route_table_association" "db_assoc_01" {
  route_table_id = aws_route_table.db_rt.id
  subnet_id      = aws_subnet.db_pri_sub_01.id
}

resource "aws_route_table_association" "db_assoc_02" {
  route_table_id = aws_route_table.db_rt.id
  subnet_id      = aws_subnet.db_pri_sub_02.id
}
