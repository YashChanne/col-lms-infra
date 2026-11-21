output "alb_dns_name" {
  description = "Open this URL in the browser to test the app"
  value       = aws_lb.alb-project-01.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.mysql_01.endpoint
}

output "vpc_id" {
  value = aws_vpc.col_lms_vpc.id
}
