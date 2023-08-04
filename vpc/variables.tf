variable "region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for VPC"
}

variable "vpc_name" {
  type        = string
  description = "VPC resource indentifier"
  default     = "SOW PACKAGE VPC"
}

variable "route_table_name" {
  type        = string
  description = "Route table resource indentifier"
  default     = "SOW PACKAGE IGW"
}

variable "subnet_name" {
  type        = string
  description = "Subnet resource indentifier"
  default     = "SOW PACKAGE SUBNET"

}

variable "public_subnets" {
  type        = list(any)
  description = "List of cidr block assigned to public subnets"

}

variable "private_subnets" {
  type        = list(any)
  description = "List of cidr block assigned to private subnets"

}

variable "aws_availability_zone_count" {
  type        = number
  description = "Number of availability zone to setup"
  default     = 1
}

variable "elastic_ip_name" {
  type        = string
  description = "Elastic IP address resource identifier"
  default     = "SOW PACKAGE EIP"
}

variable "single_nat_gateway" {
  type        = bool
  description = "When set to True. will provision one nat gateway for one availability zone else provision it for all zone"
  default     = false
}

variable "provision_nat_gateway" {
  type        = bool
  description = "When set to True. will provision nat gateways"
  default     = false
}