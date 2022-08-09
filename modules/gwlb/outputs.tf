output "gwlb" {
  description = "ARN of the gateway loadbalancer"
  value       = aws_lb.gwlb.*.arn
}