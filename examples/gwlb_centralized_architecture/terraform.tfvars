// AWS Environment -- Remove the # to before configure a value to it. 
// If you dont provide any value, it will take the default value 

############################################################
#AWS Creditials to access the AWS Cloud
#############################################################
aws_access_key = ""

aws_secret_key = ""

region = "ap-south-1"

##################################################################################
#Define CIDR, Subnets for managment and three for Inside, Outisde and DMZ
###################################################################################
service_vpc_cidr   = "172.16.0.0/16"
service_vpc_name   = "service-vpc"
service_create_igw = true

mgmt_subnet_cidr    = ["172.16.220.0/24", "172.16.210.0/24"]
outside_subnet_cidr = ["172.16.230.0/24", "172.16.241.0/24"]
diag_subnet_cidr    = ["172.16.24.0/24", "172.16.240.0/24"]

inside_subnet_cidr = ["172.16.29.0/24", "172.16.190.0/24"]

ngw_subnet_cidr   = ["172.16.211.0/24", "172.16.221.0/24"]
gwlbe_subnet_cidr = ["172.16.212.0/24", "172.16.232.0/24"]
tgw_subnet_cidr   = ["172.16.215.0/24", "172.16.225.0/24"]

lambda_subnet_cidr = "172.16.252.0/24"

ftd_mgmt_ip    = ["172.16.220.23", "172.16.210.24"]
ftd_outside_ip = ["172.16.230.22", "172.16.241.45"]
ftd_diag_ip    = ["172.16.24.43", "172.16.240.99"]
fmc_ip         = "172.16.220.87"

ftd_inside_ip = ["172.16.29.23", "172.16.190.24"]

outside_subnet_name = ["outside1", "outside2"]
mgmt_subnet_name    = ["mgmt1", "mgmt2"]
diag_subnet_name    = ["diag1", "diag2"]


gwlbe_subnet_name = ["gwlb1", "gwlb2"]
ngw_subnet_name   = ["ngw1", "ngw2"]
tgw_subnet_name   = ["tgw1", "tgw2"]

inside_subnet_name = ["inside1", "inside2"]

spoke_vpc_cidr    = "10.0.0.0/16"
spoke_vpc_name    = "spoke-vpc"
spoke_create_igw  = "false"
spoke_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
spoke_subnet_name = ["spoke1", "spoke2"]

keyname                 = "lx1"
instances_per_az        = 1
availability_zone_count = 2

gwlb_name = "GWLB"

outside_interface_sg = [
  {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["172.16.230.0/24", "172.16.241.0/24"]
    description = "HTTP Access"
  },
  {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["172.16.230.0/24", "172.16.241.0/24"]
    description = "SSH Access"
  }
]

inside_interface_sg = [
  {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["172.16.29.0/24", "172.16.190.0/24"]
    description = "HTTP Access"
  }
]

mgmt_interface_sg = [
  {
    from_port   = 8305
    protocol    = "TCP"
    to_port     = 8305
    cidr_blocks = ["0.0.0.0/0"]//["10.0.1.50/32"]
    description = "Mgmt Traffic from FMC"
  }
]

fmc_mgmt_interface_sg = [
  {
    from_port   = 443
    protocol    = "TCP"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS Access to FMC UI"
  },
  {
    from_port   = 8305
    protocol    = "TCP"
    to_port     = 8305
    cidr_blocks = ["0.0.0.0/0"]//["10.0.1.10/32", "10.0.10.10/32"]
    description = "Mgmt Traffic from FTD"
  }
]




