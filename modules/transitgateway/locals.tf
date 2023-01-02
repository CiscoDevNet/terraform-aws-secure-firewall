locals {
    tgw_subnet    = length(var.tgw_subnet_cidr) != 0 ? aws_subnet.tgw_subnet : data.aws_subnet.tgw_subnet
}