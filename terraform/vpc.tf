
resource "aws_vpc" "petclinic_vpc" {
  cidr_block= var.cidr_block_vpc
  enable_dns_hostnames = true
  enable_dns_support = true
  
    tags = {
      Name = "petclinic-vpc"
    }

  
}
