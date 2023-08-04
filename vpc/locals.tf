locals {

  tags = {
    Environment = "Dev"
    Package     = "VPC"
  }
}


azones = slice(data.aws_availability_zones.azones, 0, var.aws_availability_zone_count)
