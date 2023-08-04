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

  # GET ALL PUBLIC SUBNET IDS
  public_subnet_ids = [for key, subnet in aws_subnet.public : subnet.id]

  # GET ALL PRIVATE ROUTE TABLE IDS
  private_route_table_ids = [for key, route_table in aws_route_table.private: route_table.id]

}

