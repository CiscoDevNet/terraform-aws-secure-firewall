resource "aws_subnet" "ngw_subnet" {
  count             = length(var.ngw_subnet_cidr) != 0 ? length(var.ngw_subnet_cidr) : 0
  vpc_id            = var.vpc_id
  cidr_block        = var.ngw_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = var.ngw_subnet_name[count.index]
  }
}

resource "aws_route_table" "ngw_route" {
  count  = length(var.ngw_subnet_cidr) != 0 ? length(var.ngw_subnet_cidr) : length(var.ngw_subnet_name)
  vpc_id = var.vpc_id
  tags = {
    Name = "nat gw network Routing table"
  }
}

resource "aws_route_table_association" "ngw_association" {
  count          = length(var.ngw_subnet_cidr) != 0 ? length(var.ngw_subnet_cidr) : length(var.ngw_subnet_name)
  subnet_id      = length(var.ngw_subnet_cidr) != 0 ? aws_subnet.ngw_subnet[count.index].id : data.aws_subnet.ngw[count.index].id
  route_table_id = aws_route_table.ngw_route[count.index].id
}

resource "aws_eip" "nat_eip" {
  count = var.availability_zone_count
  vpc   = true
}

resource "aws_nat_gateway" "natgw" {
  depends_on    = [data.aws_subnet.dngw_subnet]
  count         = var.availability_zone_count
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = data.aws_subnet.dngw_subnet[count.index].id

  tags = {
    Name = "NAT-GW-${count.index + 1}"
  }
}