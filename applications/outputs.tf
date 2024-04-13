output "nlb_public_ips" {
  description = "List of public IPs of Nginx Ingress controller NLB"
  value       = [for eni in data.aws_network_interface.lb : eni.association.0.public_ip]
}