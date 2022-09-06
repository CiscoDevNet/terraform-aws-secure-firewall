# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

data "aws_availability_zones" "available" {}

data "aws_route_table" "spoke_rt" {
  count          = length(var.spoke_rt_id)
  route_table_id = var.spoke_rt_id[count.index]
}