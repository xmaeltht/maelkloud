# Output the ALB DNS Name
output "alb_dns_name" {
  value = aws_lb.main.dns_name
}