locals {

  tags = {
    Environment = "Dev"
    Package     = "VPC"
  }

  # AVAILABILITY ZONE FOR SUBNET
  azones = slice(data.aws_availability_zones.azones, 0, var.aws_availability_zone_count)

  # AVAILABILITY ZONE FOR NAT GATEWAY
  net_gw_azones_count = var.provision_nat_gateway ? var.single_nat_gateway ? 1 : var.aws_availability_zone_count : 0
  net_gw_azones       = slice(local.azones, 0, local.net_gw_azones_count)




}

