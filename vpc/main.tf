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

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    "Name" = format("public-%s", var.route_table_name)
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    "Name" = format("private-%s", var.route_table_name)
  })
}


resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id


  timeouts {
    create = "5m"
  }

  tags = merge(local.tags, {
    "Name" = var.route_table_name
  })
}

resource "aws_subnet" "public" {
  for_each                = toset(var.public_subnets)
  cidr_block              = each.key
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = element(local.azones, index(var.public_subnets, each.key))

  tags = merge(local.tags, {
    "Name" = format("%s-public-%s", var.subnet_name, index(var.public_subnets, each.key))
  })
}

resource "aws_subnet" "private" {
  for_each          = toset(var.private_subnets)
  cidr_block        = each.key
  vpc_id            = aws_vpc.main.id
  availability_zone = element(local.azones, index(var.private_subnets, each.key))

  tags = merge(local.tags, {
    "Name" = format("%s-private-%s", var.subnet_name, index(var.private_subnets, each.key))
  })
}


resource "aws_route_table_association" "public" {
    for_each = aws_subnet.public
    subnet_id = each.value.id
    route_table_id = aws_route_table.main.id
    
  
}
