variable "aws_access_key" {
  type        = string
  description = "AWS ACCESS KEY"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS SECRET KEY"
}
variable "region" {
  type        = string
  description = "AWS REGION"
  default     = "us-east-1"
}

variable "service_vpc_cidr" {
  type        = string
  description = "Service VPC CIDR"
  default     = null
}

variable "service_vpc_name" {
  type        = string
  description = "Service VPC Name"
  default     = null
}

variable "service_create_igw" {
  type        = bool
  description = "Boolean value to decide if to create IGW or not"
  default     = false
}

variable "mgmt_subnet_cidr" {
  description = "List out management Subnet CIDR . "
  type        = list(string)
  default     = []
}

variable "ftd_mgmt_ip" {
  description = "List out management IPs . "
  type        = list(string)
  default     = []
}

variable "outside_subnet_cidr" {
  description = "List out outside Subnet CIDR . "
  type        = list(string)
  default     = []
}

variable "ftd_outside_ip" {
  type        = list(string)
  description = "List outside IPs . "
  default     = []
}

variable "diag_subnet_cidr" {
  description = "List out diagonastic Subnet CIDR . "
  type        = list(string)
  default     = []
}

variable "ftd_diag_ip" {
  type        = list(string)
  description = "List out FTD Diagonostic IPs . "
  default     = []
}

variable "inside_subnet_cidr" {
  description = "List out inside Subnet CIDR . "
  type        = list(string)
  default     = []
}

variable "ftd_inside_ip" {
  description = "List FTD inside IPs . "
  type        = list(string)
  default     = []
}

variable "fmc_ip" {
  description = "List out FMCv IPs . "
  type        = string
  default     = ""
}

variable "tgw_subnet_cidr" {
  type        = list(string)
  description = "List of Transit GW Subnet CIDR"
  default     = []
}

variable "lambda_subnet_cidr" {
  type        = string
  description = "Lambda Subnet CIDR"
  default     = ""
}

variable "availability_zone_count" {
  type        = number
  description = "Spacified availablity zone count . "
  default     = 2
}

variable "mgmt_subnet_name" {
  type        = list(string)
  description = "Specified management subnet names"
  default     = []
}

variable "outside_subnet_name" {
  type        = list(string)
  description = "Specified outside subnet names"
  default     = []
}

variable "diag_subnet_name" {
  description = "Specified diagonstic subnet names"
  type        = list(string)
  default     = []
}

variable "inside_subnet_name" {
  type        = list(string)
  description = "Specified inside subnet names"
  default     = []
}

variable "tgw_subnet_name" {
  type        = list(string)
  description = "List of name for TGW Subnets"
  default     = []
}

variable "lambda_subnet_name" {
  type        = string
  description = "Name for Lambda Subnet"
  default     = ""
}

variable "outside_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outside Interface SG"
  }]
}

variable "inside_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Inside Interface SG"
  }]
}

variable "mgmt_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Mgmt Interface SG"
  }]
}

variable "fmc_mgmt_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "FMC Mgmt Interface SG"
  }]
}

variable "instances_per_az" {
  type        = number
  description = "Spacified no. of instance per az wants to be create . "
  default     = 1
}

########################################################################
## Spoke  
########################################################################

variable "spoke_vpc_cidr" {
  type        = string
  description = "Specified CIDR for VPC . "
  default     = null
}

variable "spoke_vpc_name" {
  type        = string
  description = "Specified VPC Name . "
  default     = null
}

variable "spoke_create_igw" {
  type        = string
  description = " Condition to create IGW . "
  default     = true
}

variable "spoke_subnet_cidr" {
  type        = list(string)
  description = "List out spoke Subnet CIDR . "
  default     = []
}

variable "spoke_subnet_name" {
  type        = list(string)
  description = "List out spoke Subnet names . "
  default     = []
}

variable "gwlbe_subnet_cidr" {
  type        = list(string)
  description = "List out GWLBE Subnet CIDR . "
  default     = []
}

variable "gwlbe_subnet_name" {
  type        = list(string)
  description = "List out GWLBE Subnet names . "
  default     = []
}

variable "ngw_subnet_cidr" {
  type        = list(string)
  description = "List out NGW Subnet CIDR . "
  default     = []
}

variable "ngw_subnet_name" {
  type        = list(string)
  description = "List out NGW Subnet names . "
  default     = []
}

########################################################################
## Instances
########################################################################

variable "ftd_size" {
  type        = string
  description = "FTD Instance Size"
  default     = "c5.xlarge"
}

variable "keyname" {
  type        = string
  description = "key to be used for the instances"
}

########################################################################
## GatewayLoadbalncer 
########################################################################

variable "gwlb_name" {
  type        = string
  description = "name for Gateway loadbalancer"
}

variable "transit_gateway_name" {
  type        = string
  description = "Name of the Transit Gateway created"
  default     = null
}

variable "use_ftd_eip" {
  description = "boolean value to use EIP on FTD or not"
  type        = bool
  default     = false
}

variable "use_fmc_eip" {
  description = "boolean value to use EIP on FMC or not"
  type        = bool
  default     = false
}

variable "ftd_version" {
  default = "ftdv-7.3.0"
}

variable "fmc_version" {
  default = "fmcv-7.2.0"
}

variable "create_fmc" {
  description = "Boolean value to create FMC or not"
  type        = bool
  default     = true
}

variable "lambda_func_name" {
    type = string
    default = "fmc_config_func"
}