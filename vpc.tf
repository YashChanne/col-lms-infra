resource "aws_vpc" "col_lms_vpc" {
  cidr_block           = var.col_lms_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "col-lms-vpc-01"
  }
}
