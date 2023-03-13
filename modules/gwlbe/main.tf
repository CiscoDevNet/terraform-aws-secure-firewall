# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

resource "aws_subnet" "gwlbe_subnet" {
  count             = length(var.gwlbe_subnet_cidr) != 0 ? length(var.gwlbe_subnet_cidr) : 0
  vpc_id            = var.vpc_id
  cidr_block        = var.gwlbe_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = var.gwlbe_subnet_name[count.index]
  }
}

resource "aws_route_table" "gwlbe_route" {
  count  = length(var.ngw_id) != 0 ? length(var.ngw_id) : 0
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.ngw_id[count.index]
  }

  tags = {
    Name = "GWLB-RT-${count.index + 1}"
  }
}

resource "aws_route_table" "igw_route" {
  count  = var.igw_id != "" ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "GWLB-RT-${count.index + 1}"
  }
}

resource "aws_route_table_association" "gwlbe_association" {
  count          = length(var.ngw_id) != 0 ? length(var.ngw_id) : 0
  subnet_id      = length(var.gwlbe_subnet_cidr) != 0 ? aws_subnet.gwlbe_subnet[count.index].id : data.aws_subnet.gwlbe[count.index].id
  route_table_id = aws_route_table.gwlbe_route[count.index].id
}

resource "aws_vpc_endpoint_service" "glwbes" {
  acceptance_required        = false
  gateway_load_balancer_arns = [var.gwlb[0]]
}

resource "aws_vpc_endpoint" "glwbe" {
  count             = length(var.gwlbe_subnet_cidr)
  service_name      = aws_vpc_endpoint_service.glwbes.service_name
  subnet_ids        = [aws_subnet.gwlbe_subnet[count.index].id]
  vpc_endpoint_type = aws_vpc_endpoint_service.glwbes.service_type
  vpc_id            = var.vpc_id
  tags = {
    Name = "GWLBE-${count.index + 1}"
  }
}

