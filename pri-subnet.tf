# ---------- App tier (private) ----------
resource "aws_subnet" "app_pri_sub_01" {
  vpc_id            = aws_vpc.col_lms_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "app-pri-sub-01"
  }
}

resource "aws_subnet" "app_pri_sub_02" {
  vpc_id            = aws_vpc.col_lms_vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "app-pri-sub-02"
  }
}

# ---------- Database tier (private, no internet route) ----------
resource "aws_subnet" "db_pri_sub_01" {
  vpc_id            = aws_vpc.col_lms_vpc.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "db-pri-sub-01"
  }
}

resource "aws_subnet" "db_pri_sub_02" {
  vpc_id            = aws_vpc.col_lms_vpc.id
  cidr_block        = "10.0.22.0/24"
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "db-pri-sub-02"
  }
}
