output "nlb_dns_name" {
  description = "DNS name of Nginx Ingress controller NLB"
  value       = data.aws_lb.ingress.dns_name
}