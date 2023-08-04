resource "aws_vpc" "main" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = var.vpc_cidr_block


  tags = merge(local.tags, {
    "Name" = var.vpc_name
  })
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    "Name" = var.igw_name
  })
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    "Name" = var.route_table_name
  })
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    "Name" = var.route_table_name
  })
}


resource "aws_route" "public" {
  route_table_id = aws_route_table.main
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main


  timeouts {
    create = "5m"
  }

  tags = merge(local.tags, {
    "Name" = var.route_table_name
  })
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    map_public_ip_on_launch = true

  tags = merge(local.tags, {
    "Name" = var.subnet_name
  })  
}