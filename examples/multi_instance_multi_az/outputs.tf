output "instance_ip" {
  description = "Public IP address of the FTD instances"
  value       = module.instance.instance_private_ip
}