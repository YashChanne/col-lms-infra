# NAT gateway lets private app servers reach the internet (apt install, updates)
# without being reachable from the internet. NOTE: NAT gateway costs money per hour,
# so run `terraform destroy` after testing.
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-01"
  }
}

resource "aws_nat_gateway" "nat_01" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.col_lms_pub_sub_01.id

  tags = {
    Name = "nat-01"
  }

  depends_on = [aws_internet_gateway.col_igw]
}
