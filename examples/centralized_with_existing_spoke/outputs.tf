output "instance_ip" {
  description = "Public IP address of the FTD instances"
  value       = module.instance.instance_private_ip
}

output "internet_gateway" {
  description = "Internet Gateway ID"
  value       = module.service_network.internet_gateway
}