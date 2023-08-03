variable "region" {
  description = "AWS region to create resources in"
  type  = string
  default = "ap-southeast-2"
}

variable "vpc_cidr_block" {
  type = string
  description = "CIDR block for VPC"
}

variable "vpc_name" {
  type = string
  description = "VPC resource indentifier"
  default = "Sow-Package-VPC"
}