<!-- BEGIN_TF_DOCS -->
# Deployment of Active/Active FTDv(stateless) with NLB in Two different AZ with FMCv

## Overview

Using this Terraform template, two instances of FTD will be deployed in  Active/Active using AWS native Network Load Balancer in two different Availability Zone, with FMC in a new VPC with the following components, 

- one new VPC with four subnets (1 Management networks, 3 data networks)
- Security groups associated with the created subnets. 
*Note*: Change the security groups to allow only the required traffic to and from the specific IP address and ports as required.

- Routing table attachment to each of these subnets. 
- EIP attachment to the Management subnet. (Optional) 
- One External Load Balancer.

## Topology

<img src="../../images/FTD_AA_Multi_AZ.png" alt="FTD A/A in Multiple AZ" style="max-width:50%;">

## Prerequisites

Make sure you have the following:

- Terraform – Learn how to download and set up [here](https://learn.hashicorp.com/terraform/getting-started/install.html).
- Programmatic access to AWS account with CLI - learn how to set up [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_instance"></a> [instance](#module\_instance) | ./modules/firewall_instance | n/a |
| <a name="module_service_network"></a> [service\_network](#module\_service\_network) | ./modules/network | n/a |

## Resources

| Name | Type |
|------|------|
| aws_lb | resource |
| aws_lb_target_group | resource |
| aws_lb_listener | resource |
| aws_lb_target_group_attachment | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS ACCESS KEY | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS SECRET KEY | `string` | n/a | yes |
| <a name="input_keyname"></a> [keyname](#input\_keyname) | key to be used for the instances | `string` | n/a | yes |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Spacified availablity zone count . | `number` | `2` | no |
| <a name="input_diag_subnet_cidr"></a> [diag\_subnet\_cidr](#input\_diag\_subnet\_cidr) | List out diagonastic Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_diag_subnet_name"></a> [diag\_subnet\_name](#input\_diag\_subnet\_name) | Specified diagonstic subnet names | `list(string)` | `[]` | no |
| <a name="input_fmc_ip"></a> [fmc\_ip](#input\_fmc\_ip) | List out FMCv IPs . | `string` | `""` | no |
| <a name="input_fmc_mgmt_interface_sg"></a> [fmc\_mgmt\_interface\_sg](#input\_fmc\_mgmt\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_ftd_diag_ip"></a> [ftd\_diag\_ip](#input\_ftd\_diag\_ip) | List out FTD Diagonostic IPs . | `list(string)` | `[]` | no |
| <a name="input_ftd_inside_ip"></a> [ftd\_inside\_ip](#input\_ftd\_inside\_ip) | List FTD inside IPs . | `list(string)` | `[]` | no |
| <a name="input_ftd_mgmt_ip"></a> [ftd\_mgmt\_ip](#input\_ftd\_mgmt\_ip) | List out management IPs . | `list(string)` | `[]` | no |
| <a name="input_ftd_outside_ip"></a> [ftd\_outside\_ip](#input\_ftd\_outside\_ip) | List outside IPs . | `list(string)` | `[]` | no |
| <a name="input_ftd_size"></a> [ftd\_size](#input\_ftd\_size) | FTD Instance Size | `string` | `"c5.xlarge"` | no |
| <a name="input_inside_interface_sg"></a> [inside\_interface\_sg](#input\_inside\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_inside_subnet_cidr"></a> [inside\_subnet\_cidr](#input\_inside\_subnet\_cidr) | List out inside Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_inside_subnet_name"></a> [inside\_subnet\_name](#input\_inside\_subnet\_name) | Specified inside subnet names | `list(string)` | `[]` | no |
| <a name="input_instances_per_az"></a> [instances\_per\_az](#input\_instances\_per\_az) | Spacified no. of instance per az wants to be create . | `number` | `1` | no |
| <a name="input_mgmt_interface_sg"></a> [mgmt\_interface\_sg](#input\_mgmt\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_mgmt_subnet_cidr"></a> [mgmt\_subnet\_cidr](#input\_mgmt\_subnet\_cidr) | List out management Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_mgmt_subnet_name"></a> [mgmt\_subnet\_name](#input\_mgmt\_subnet\_name) | Specified management subnet names | `list(string)` | `[]` | no |
| <a name="input_outside_interface_sg"></a> [outside\_interface\_sg](#input\_outside\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_outside_subnet_cidr"></a> [outside\_subnet\_cidr](#input\_outside\_subnet\_cidr) | List out outside Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_outside_subnet_name"></a> [outside\_subnet\_name](#input\_outside\_subnet\_name) | Specified outside subnet names | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS REGION | `string` | `"us-east-1"` | no |
| <a name="input_service_create_igw"></a> [service\_create\_igw](#input\_service\_create\_igw) | Boolean value to decide if to create IGW or not | `bool` | `false` | no |
| <a name="input_service_vpc_cidr"></a> [service\_vpc\_cidr](#input\_service\_vpc\_cidr) | Service VPC CIDR | `string` | `null` | no |
| <a name="input_service_vpc_name"></a> [service\_vpc\_name](#input\_service\_vpc\_name) | Service VPC Name | `string` | `null` | no |
| <a name="input_use_fmc_eip"></a> [use\_fmc\_eip](#input\_use\_fmc\_eip) | boolean value to use EIP on FMC or not | `bool` | `false` | no |
| <a name="input_use_ftd_eip"></a> [use\_ftd\_eip](#input\_use\_ftd\_eip) | boolean value to use EIP on FTD or not | `bool` | `false` | no |
| <a name="input_listener_ports"></a> [input\_listener\_ports](#input\_input\_listener\_ports) | Listener ports for the Network load balancer | <pre>list(object({<br>protocol = string<br>port = number})</pre> | <pre>[{<br>protocol = "TCP"<br>port = 2<br>},<br>{<br>protocol = "TCP"<br>port = 443<br>}]<br>}</pre> | no |
| <a name="input_health_check"></a> [input\_health\_check](#input\_input\_health\_check) | list of ports to be used for health check of target instances | <pre>object({<br>protocol = string<br>port = number})</pre> | <pre>{<br>protocol = "TCP"<br>port = 22<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_ip"></a> [instance\_ip](#output\_instance\_ip) | Private IP address of the FTD instances |

## Post Deployment Procedure

Once the FTD and FMC are successfully deployed, the following steps need to be done manually based on your requirement.

The Load balancing "Health Check" is configured to probe the FTD in port 22 through the external interfaces. If any of these fails, the FTD goes into unhealthy_state, and the traffic will go thru the healthy FTD.

To make "health_check" work, you need to enable the ssh in the FTD "platform settings" for the Loadbalancer IP address to access it, as mentioned in the below screenshot.

<img src="../../images/FTD_Platformsetting_SSH.png" alt="FTD Platform settings SSH" style="max-width:50%;">

This configuration is required if you want to NAT the workloads inside the network using the interface's IP address. Both source and destination NAT needs to be configured so that the traffic will be symmetric.


But usually, the servers inside the network, accessed from the public using the static NAT.  To achieve it, you need to configure the following things, 

1) Configure the secondary IP address set in the AWS External interfaces on both the FTDs. 
	For Example, if you have ten web servers to be accessed from outside, each external interface of AWS should be configured with ten IP addresses. 
2) Configure the Static NAT in FTD Firewall to map the inside host's IP addresses with the secondary IP addresses. 
3) Include the Dynamic Source NAT with the inside interface IP addresses of FTD so that the return traffic hits the same firewall. 
4) To have the Client's IP addresses' visibility, enable the "Preserve Client IP address" option in AWS Target group(s) attached with the load balancers.


Note: There are different ways to configure the External Load Balancer and the FTDs to send the traffic across the FTDs for Active/Active Load Balancing with stateless failover. It differs based on the customer's network setup. The details mentioned above are just for the references.  
<!-- END_TF_DOCS -->