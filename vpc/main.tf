resource "aws_vpc" "main" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = var.vpc_cidr_block


  tags = merge(local.tags, {
    "Name" = var.vpc_name
  })
}

### SETTING UP SUBNET AND ROUTE TABLE 
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    "Name" = var.internet_gateway_name
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    "Name" = format("public-%s", var.route_table_name)
  })
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  timeouts {
    create = "5m"
  }
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

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = local.azones
  vpc_id   = aws_vpc.main.id

  tags = merge(local.tags, {
    "Name" = format("%s-private-%s", var.route_table_name, each.key)
  })
}

resource "aws_route" "private" {
  for_each               = local.azones
  route_table_id         = aws_route_table.private[each.key].id
  nat_gateway_id         = aws_nat_gateway.main[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  timeouts {
    create = "5m"
  }
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

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = element(local.private_route_table_ids, index(aws_subnet.private, each.key))
}


### SETTING UP ELASTIC IP ADRRESS
resource "aws_eip" "main" {
  for_each = toset(local.net_gw_azones)
  vpc      = true

  tags = merge(local.tags, {
    "Name" = format("%s-%s", var.elastic_ip_name, each.key)
  })
}


## SETTING UP NAT GATEWAY
resource "aws_nat_gateway" "main" {
  for_each      = aws_eip.main
  allocation_id = each.value.id
  subnet_id     = element(local.public_subnet_ids, index(aws_eip.main, each.key))


  tags = merge(local.tags, {
    "Name" = format("%s-%s", var.nat_gateway_name, each.key)
  })

  depends_on = [aws_internet_gateway.main]

}