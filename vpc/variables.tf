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
  type = string
  description = "Subnet resource indentifier"
  default = "SOW PACKAGE SUBNET"
  
}