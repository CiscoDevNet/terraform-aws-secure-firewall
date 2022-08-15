module "service_network" {
  source                = "../../modules/network"
  vpc_cidr              = var.service_vpc_cidr
  vpc_name              = var.service_vpc_name
  create_igw            = var.service_create_igw
  mgmt_subnet_cidr      = var.mgmt_subnet_cidr
  ftd_mgmt_ip           = var.ftd_mgmt_ip
  outside_subnet_cidr   = var.outside_subnet_cidr
  ftd_outside_ip        = var.ftd_outside_ip
  diag_subnet_cidr      = var.diag_subnet_cidr
  ftd_diag_ip           = var.ftd_diag_ip
  inside_subnet_cidr    = var.inside_subnet_cidr
  ftd_inside_ip         = var.ftd_inside_ip
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
  source           = "../../modules/network"
  vpc_cidr         = var.spoke_vpc_cidr
  vpc_name         = var.spoke_vpc_name
  create_igw       = var.spoke_create_igw
  mgmt_subnet_cidr = var.spoke_subnet_cidr
  mgmt_subnet_name = var.spoke_subnet_name
}

module "instance" {
  source                  = "../../modules/firewall_instance"
  keyname                 = var.keyname
  ftd_size                = var.ftd_size
  instances_per_az        = var.instances_per_az
  availability_zone_count = var.availability_zone_count
  fmc_mgmt_ip             = var.fmc_ip
  ftd_mgmt_interface      = module.service_network.mgmt_interface
  ftd_inside_interface    = module.service_network.inside_interface
  ftd_outside_interface   = module.service_network.outside_interface
  ftd_diag_interface      = module.service_network.diag_interface
  fmcmgmt_interface       = module.service_network.fmcmgmt_interface
}

module "nat_gw" {
  source                  = "../../modules/nat_gw"
  ngw_subnet_cidr         = var.ngw_subnet_cidr
  ngw_subnet_name         = var.ngw_subnet_name
  availability_zone_count = var.availability_zone_count
  vpc_id                  = module.service_network.vpc_id
}

module "gwlb" {
  source      = "../../modules/gwlb"
  gwlb_name   = var.gwlb_name
  gwlb_subnet = module.service_network.outside_subnet
  gwlb_vpc_id = module.service_network.vpc_id
  instance_ip = var.ftd_outside_ip
}

module "gwlbe" {
  source            = "../../modules/gwlbe"
  gwlbe_subnet_cidr = var.gwlbe_subnet_cidr
  gwlbe_subnet_name = var.gwlbe_subnet_name
  vpc_id            = module.service_network.vpc_id
  ngw_id            = module.nat_gw.ngw
  gwlb              = module.gwlb.gwlb
}

module "transitgateway" {
  source                      = "../../modules/transitgateway"
  vpc_service_id              = module.service_network.vpc_id
  vpc_spoke_id                = module.spoke_network.vpc_id
  tgw_subnet_cidr             = var.tgw_subnet_cidr
  tgw_subnet_name             = var.tgw_subnet_name
  vpc_spoke_cidr              = var.spoke_vpc_cidr
  spoke_subnet_id             = module.spoke_network.mgmt_subnet
  spoke_rt_id                 = module.spoke_network.mgmt_rt_id
  gwlbe                       = module.gwlbe.gwlb_endpoint_id
  transit_gateway_name        = var.transit_gateway_name
  availability_zone_count     = var.availability_zone_count
  nat_subnet_routetable_ids   = module.nat_gw.nat_rt_id
  gwlbe_subnet_routetable_ids = module.gwlbe.gwlbe_rt_id
}

