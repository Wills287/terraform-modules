output "vpc_id" {
  description = "Id of the VPC"
  value = join("", aws_vpc.this.*.id)
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value = join("", aws_vpc.this.*.cidr_block)
}

output "vpc_main_route_table_id" {
  description = "Id of the main route table associated with this VPC"
  value = join("", aws_vpc.this.*.main_route_table_id)
}

output "vpc_default_network_acl_id" {
  description = "Id of the network ACL created by default on VPC creation"
  value = join("", aws_vpc.this.*.default_network_acl_id)
}

output "vpc_default_security_group_id" {
  description = "Id of the security group created by default on VPC creation"
  value = join("", aws_vpc.this.*.default_security_group_id)
}

output "vpc_default_route_table_id" {
  description = "Id of the route table created by default on VPC creation"
  value = join("", aws_vpc.this.*.default_route_table_id)
}

output "vpc_ipv6_association_id" {
  description = "Association id for the IPv6 CIDR block"
  value = join("", aws_vpc.this.*.ipv6_association_id)
}

output "vpc_ipv6_cidr_block" {
  description = "VPC IPv6 CIDR block"
  value = join("", aws_vpc.this.*.ipv6_cidr_block)
}

output "igw_id" {
  description = "Id of the Internet Gateway"
  value = join("", aws_internet_gateway.this.*.id)
}
