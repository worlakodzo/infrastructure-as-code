resource "aws_vpc" "main" {
    enable_dns_hostnames = true
    enable_dns_support = true
    cidr_block = var.vpc_cidr_block


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