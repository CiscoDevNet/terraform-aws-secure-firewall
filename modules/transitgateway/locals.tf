locals {
    tgw           = var.create_tgw ? aws_ec2_transit_gateway.tgw[0] : data.aws_ec2_transit_gateway.tgw[0]
    tgw_subnet    = length(var.tgw_subnet_cidr) != 0 ? aws_subnet.tgw_subnet[0] : data.aws_subnet.tgw_subnet[0]
}