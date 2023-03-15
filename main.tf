module "service_network" {
  #source                = "CiscoDevNet/secure-firewall/aws//modules/network"
  source                = "/Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/network"
  vpc_name              = var.service_vpc_name
  create_fmc            = var.create_fmc
  create_igw            = var.service_create_igw
  igw_name              = var.service_igw_name
  mgmt_subnet_cidr      = var.mgmt_subnet_cidr
  #ftd_mgmt_ip           = var.ftd_mgmt_ip
  outside_subnet_cidr   = var.outside_subnet_cidr
  #ftd_outside_ip        = var.ftd_outside_ip
  diag_subnet_cidr      = var.diag_subnet_cidr
  #ftd_diag_ip           = var.ftd_diag_ip
  inside_subnet_cidr    = var.inside_subnet_cidr
  #ftd_inside_ip         = var.ftd_inside_ip
  fmc_ip                = var.fmc_ip
  mgmt_subnet_name      = var.mgmt_subnet_name
  outside_subnet_name   = var.outside_subnet_name
  diag_subnet_name      = var.diag_subnet_name
  inside_subnet_name    = var.inside_subnet_name
  outside_interface_sg  = var.outside_interface_sg
  inside_interface_sg   = var.inside_interface_sg
  mgmt_interface_sg     = var.mgmt_interface_sg
  fmc_mgmt_interface_sg = var.fmc_mgmt_interface_sg
  use_fmc_eip           = var.use_fmc_eip
  use_ftd_eip           = var.use_ftd_eip
}

module "spoke_network" {
  #source              = "CiscoDevNet/secure-firewall/aws//modules/network"
  source               = "/Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/network"
  vpc_name             = var.spoke_vpc_name
  vpc_cidr             = var.spoke_vpc_cidr
  create_igw           = var.spoke_create_igw
  igw_name             = var.spoke_igw_name
  create_fmc           = var.create_fmc
  outside_subnet_cidr  = var.spoke_subnet_cidr
  outside_subnet_name  = var.spoke_subnet_name
}

module "instance" {
  #source                  = "CiscoDevNet/secure-firewall/aws//modules/firewall_instance"
  source                = "/Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/firewall_instance"
  ftd_version             = var.ftd_version
  create_fmc              = var.create_fmc
  keyname                 = var.keyname
  ftd_size                = var.ftd_size
  instances_per_az        = var.instances_per_az
  availability_zone_count = var.availability_zone_count
  fmc_mgmt_ip             = var.fmc_ip
  ftd_mgmt_interface      = module.service_network.mgmt_interface
  ftd_inside_interface    = module.service_network.inside_interface
  ftd_outside_interface   = module.service_network.outside_interface
  ftd_diag_interface      = module.service_network.diag_interface
}

module "nat_gw" {
  #source                  = "CiscoDevNet/secure-firewall/aws//modules/nat_gw"
  source                = "/Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/nat_gw"
  ngw_subnet_cidr         = var.ngw_subnet_cidr
  ngw_subnet_name         = var.ngw_subnet_name
  availability_zone_count = var.availability_zone_count
  vpc_id                  = module.service_network.vpc_id
  internet_gateway        = module.service_network.internet_gateway
}

module "gwlb" {
  #source      = "CiscoDevNet/secure-firewall/aws//modules/gwlb"
  source                = "/Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/gwlb"
  gwlb_name   = var.gwlb_name
  gwlb_subnet = module.service_network.outside_subnet
  gwlb_vpc_id = module.service_network.vpc_id
  #instance_ip = var.ftd_outside_ip
  instance_ip = module.service_network.outside_interface_ip
}

module "gwlbe" {
  #source            = "CiscoDevNet/secure-firewall/aws//modules/gwlbe"
  source                = "/Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/gwlbe"
  gwlbe_subnet_cidr = var.gwlbe_subnet_cidr
  gwlbe_subnet_name = var.gwlbe_subnet_name
  vpc_id            = module.service_network.vpc_id
  ngw_id            = module.nat_gw.ngw
  gwlb              = module.gwlb.gwlb
}

module "transitgateway" {
  #source                      = "CiscoDevNet/secure-firewall/aws//modules/transitgateway"
  source                = "/Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/transitgateway"
  create_tgw                  = var.create_tgw
  vpc_service_id              = module.service_network.vpc_id
  vpc_spoke_id                = module.spoke_network.vpc_id
  tgw_subnet_cidr             = var.tgw_subnet_cidr
  tgw_subnet_name             = var.tgw_subnet_name
  vpc_spoke_cidr              = module.spoke_network.vpc_cidr
  spoke_subnet_id             = module.spoke_network.outside_subnet
  spoke_rt_id                 = module.spoke_network.outside_rt_id
  gwlbe                       = module.gwlbe.gwlb_endpoint_id
  transit_gateway_name        = var.transit_gateway_name
  availability_zone_count     = var.availability_zone_count
  nat_subnet_routetable_ids   = module.nat_gw.nat_rt_id
  gwlbe_subnet_routetable_ids = module.gwlbe.gwlbe_rt_id
}

#--------------------------------------------------------------------

#the code waits for 600 seconds for the resources above to be deployed and up
resource "time_sleep" "wait_720_seconds" {
  depends_on = [
    module.instance
  ]
  create_duration = "720s"
}

resource "aws_subnet" "lambda" {
  vpc_id     = data.aws_vpc.ftd_vpc.id
  cidr_block = var.lambda_subnet_cidr

  tags = {
    Name = var.lambda_subnet_name
  }
}

resource "aws_security_group" "sg_for_lambda" {
  name   = "lambda_sg"
  vpc_id = data.aws_vpc.ftd_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.16.220.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "autoscale_layer.zip"
  layer_name = "fmc_config_layer"

  compatible_runtimes = ["python3.9"]
}

resource "aws_lambda_function" "lambda" {
  filename      = "fmc_latest.py.zip"
  function_name = var.lambda_func_name
  role          = "arn:aws:iam::399918941163:role/service-role/sameesin_test-role-yao0bkem" //data.aws_iam_role.iam_for_lambda.arn
  handler       = "fmc_latest.lambda_handler"
  runtime       = "python3.9"
  layers        = [aws_lambda_layer_version.lambda_layer.arn]
  timeout       = 900
  vpc_config {
    subnet_ids         = [aws_subnet.lambda.id]
    security_group_ids = [aws_security_group.sg_for_lambda.id]
  }

  environment {
    variables = {
      ADDR     = var.fmc_ip,
      USERNAME = var.fmc_username,
      PASSWORD = var.fmc_password,
      FTD1     = module.service_network.mgmt_interface_ip[0],
      FTD2     = module.service_network.mgmt_interface_ip[1],
      gw1      = var.ftd_inside_gw[0],
      gw2      = var.ftd_inside_gw[1]
    }
  }
}