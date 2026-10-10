variable "name" {
  description = "Name prefix for network resources"
  type        = string
}
variable "cidr_block" {
  description = "CIDR range for the network"
  type        = string
  default     = "10.0.0.0/16"
}
variable "availability_zones" {
  description = "AZs to spread subnets across for failure-domain isolation"
  type        = list(string)
}
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags       = { Name = var.name }
}
resource "aws_subnet" "this" {
  for_each          = toset(var.availability_zones)
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value
  cidr_block        = cidrsubnet(var.cidr_block, 4, index(var.availability_zones, each.value))
  tags              = { Name = "${var.name}-${each.value}" }
}
output "vpc_id" {
  value = aws_vpc.this.id
}
output "subnet_ids" {
  value = [for s in aws_subnet.this : s.id]
}
