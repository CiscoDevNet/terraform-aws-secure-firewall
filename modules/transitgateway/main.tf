# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

resource "aws_subnet" "tgw_subnet" {
  count             = length(var.tgw_subnet_cidr) != 0 ? length(var.tgw_subnet_cidr) : 0
  vpc_id            = var.vpc_service_id
  cidr_block        = var.tgw_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.tgw_subnet_name[count.index]}"
  }
}

resource "aws_route_table" "tgw_route" {
  count  = var.availability_zone_count
  vpc_id = var.vpc_service_id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = var.gwlbe[count.index]
  }
}

resource "aws_route_table_association" "attach_to_service_sub" {
  count          = var.availability_zone_count
  subnet_id      = aws_subnet.tgw_subnet[count.index].id
  route_table_id = aws_route_table.tgw_route[count.index].id
}

resource "aws_route" "spoke_route" {
  count                  = length(data.aws_route_table.spoke_rt)
  route_table_id         = data.aws_route_table.spoke_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = local.tgw.id
}

###########################################################################################################################
# Transit Gateway
###########################################################################################################################

resource "aws_ec2_transit_gateway" "tgw" {
  count = var.create_tgw ? 1 : 0
  tags = {
    Name = var.transit_gateway_name
  }
}

###########################################################################################################################
# Transit Gateway Attachments
###########################################################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_att_service_vpc" {
  subnet_ids                                      = aws_subnet.tgw_subnet.*.id
  transit_gateway_id                              = local.tgw.id
  vpc_id                                          = var.vpc_service_id
  appliance_mode_support                          = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "tgw-att-service-vpc"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_att_spoke_vpc" {
  subnet_ids                                      = var.spoke_subnet_id
  transit_gateway_id                              = local.tgw.id
  vpc_id                                          = var.vpc_spoke_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "tgw-att-spoke-vpc"
  }
}

###########################################################################################################################
# Routes
###########################################################################################################################

resource "aws_ec2_transit_gateway_route_table" "rt_service_vpc_attach" {
  transit_gateway_id = local.tgw.id
}

resource "aws_ec2_transit_gateway_route_table" "rt_spoke_vpc_attach" {
  transit_gateway_id = local.tgw.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tg_rt_assoc_service_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_service_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_service_vpc_attach.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tg_rt_assoc_spoke_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_spoke_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach.id
}

resource "aws_ec2_transit_gateway_route" "default_rout_to_service_vpc" {
  destination_cidr_block         = var.vpc_spoke_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_spoke_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_service_vpc_attach.id
}

resource "aws_ec2_transit_gateway_route" "default_rout_to_spoke_vpc" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_service_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach.id
}

##################################################################################################################################
#Additional Routes
##################################################################################################################################

resource "aws_route" "nat_route" {
  count                  = length(var.nat_subnet_routetable_ids)
  route_table_id         = var.nat_subnet_routetable_ids[count.index]
  destination_cidr_block = var.vpc_spoke_cidr
  vpc_endpoint_id        = var.gwlbe[count.index]
}

resource "aws_route" "gwlbe_route" {
  count                  = length(var.gwlbe_subnet_routetable_ids)
  route_table_id         = var.gwlbe_subnet_routetable_ids[count.index]
  destination_cidr_block = var.vpc_spoke_cidr
  transit_gateway_id     = local.tgw.id
}

