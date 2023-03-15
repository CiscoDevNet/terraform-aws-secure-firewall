output "instance_ip" {
  description = "Public IP address of the FTD instances"
  value       = module.instance.instance_private_ip
}

# output "result_entry" {
#   value = jsondecode(data.aws_lambda_invocation.example.result)["key1"]
# }

output "internet_gateway" {
  description = "Internet Gateway ID"
  value       = module.service_network.internet_gateway
}

