variable "ngw_subnet_cidr" {
  description = "Specified ngw subnet CIDR"
  type        = list(string)
  default     = []
}

variable "ngw_subnet_name" {
  description = "Specified ngw subnet name"
  type        = list(string)
  default     = []
}

variable "availability_zone_count" {
  description = "Specified availablity zone count"
  type        = number
  default     = 2
}

variable "vpc_id" {
  description = "Specified VPC ID"
  type        = string
  default     = ""
}
 