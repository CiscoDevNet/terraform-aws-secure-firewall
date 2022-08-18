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

#########################################################################################################
# Creation of Network Load Balancer
#########################################################################################################

resource "aws_lb" "external01_lb" {
  name                             = "External01-LB"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = "true"
  subnets                          = module.service_network.outside_subnet
}

resource "aws_lb_target_group" "front_end1_1" {
  count       = length(var.listener_ports)
  name        = tostring("fe1-1-${lookup(var.listener_ports[count.index], "port", null)}")
  port        = lookup(var.listener_ports[count.index], "port", null)
  protocol    = lookup(var.listener_ports[count.index], "protocol", null)
  target_type = "ip"
  vpc_id      = module.service_network.vpc_id

  health_check {
    interval = 30
    protocol = var.health_check.protocol
    port     = var.health_check.port
  }
}

resource "aws_lb_listener" "listener1_1" {
  load_balancer_arn = aws_lb.external01_lb.arn
  count             = length(var.listener_ports)
  port              = lookup(var.listener_ports[count.index], "port", null)
  protocol          = lookup(var.listener_ports[count.index], "protocol", null)
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end1_1[count.index].arn
  }
}

resource "aws_lb_target_group_attachment" "target1_1a" {
  count            = length(var.listener_ports)
  depends_on       = [aws_lb_target_group.front_end1_1]
  target_group_arn = aws_lb_target_group.front_end1_1[count.index].arn
  target_id        = var.ftd_outside_ip[0]
}

resource "aws_lb_target_group_attachment" "target1_2a" {
  count            = length(var.listener_ports)
  depends_on       = [aws_lb_target_group.front_end1_1]
  target_group_arn = aws_lb_target_group.front_end1_1[count.index].arn
  target_id        = var.ftd_outside_ip[1]
}
