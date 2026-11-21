# AWS Three-Tier Architecture with Terraform

A three-tier web infrastructure on AWS (ap-south-1) written entirely in Terraform.
Built as a team project during my Cloud & DevOps internship and extended on my own
with private subnets, a NAT gateway and an RDS database.

## Architecture

```
Internet
   |
Internet Gateway
   |
[ Public subnets (2 AZs) ]  -->  Application Load Balancer  (HTTP :80, health checks on /)
   |                              NAT Gateway (outbound access for private servers)
[ Private app subnets (2 AZs) ] --> Auto Scaling Group of EC2 (nginx), 1-3 instances
   |
[ Private DB subnets (2 AZs) ]  --> RDS MySQL (not publicly accessible)
```

| Tier | Resources |
|------|-----------|
| Web | VPC, 2 public subnets, Internet Gateway, ALB, target group, listener |
| App | 2 private subnets, NAT Gateway, Launch Template, Auto Scaling Group |
| Data | 2 private DB subnets, DB subnet group, RDS MySQL 8.0 |
| Security | ALB SG (80/443 from internet) -> App SG (80 from ALB only) -> DB SG (3306 from App only) |

## Security decisions
- App servers and the database are in private subnets and have no public IP.
- Each tier only accepts traffic from the tier in front of it (security group chaining).
- No SSH port is open; no passwords in code (RDS password is generated and kept in AWS Secrets Manager).
- Terraform state is stored remotely in an S3 backend.

## How to run
```bash
terraform init
terraform plan
terraform apply
# open the alb_dns_name output in a browser; refresh to see different servers answer
terraform destroy   # always destroy after testing (NAT gateway and RDS cost money)
```

## Tech
AWS (VPC, EC2, ALB, Auto Scaling, NAT, RDS, S3), Terraform, Git/GitHub.

## What I would improve next
HTTPS with ACM certificate, RDS Multi-AZ, CloudWatch alarms for the Auto Scaling policy, and a CI pipeline running `terraform validate` on every push.
