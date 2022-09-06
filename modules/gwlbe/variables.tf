# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

variable "gwlbe_subnet_cidr" {
  description = "GWLB-Endpoint subnet CIDR"
  type        = list(string)
  default     = []
}

variable "gwlbe_subnet_name" {
  description = "GWLB-Endpoint subnet name"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  type        = string
  description = "ID of the service VPC"
}

variable "ngw_id" {
  type        = list(string)
  description = "NAT GW Subnet ID"
}

variable "gwlb" {
  type        = list(string)
  description = "Gateway Loadbalancer arn"
}