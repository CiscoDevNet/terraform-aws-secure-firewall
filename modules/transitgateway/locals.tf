locals {
    tgw           = var.create_tgw ? aws_ec2_transit_gateway.tgw[0].id : data.aws_ec2_transit_gateway.tgw[0].id
    tgw_subnet    = length(var.tgw_subnet_cidr) != 0 ? aws_subnet.tgw_subnet.*.id : data.aws_subnet.tgw_subnet.*.id
}