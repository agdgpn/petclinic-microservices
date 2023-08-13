// subnet privé dans l'az 1
resource "aws_subnet" "petclinic_private_sn_1" {
  availability_zone = var.az[0]
  map_public_ip_on_launch = false
  cidr_block = var.private_subnet_cidr_blocks[0]
  vpc_id =  aws_vpc.petclinic_vpc.id
  tags = {
    Name = "petclinic-private-SN-1"
   "kubernetes.io/role/internal-elb" = 1

  }
}
// subnet public dans l'az1
resource "aws_subnet" "petclinic_public_sn_1" {
  
  availability_zone = var.az[0]
  map_public_ip_on_launch = true
  cidr_block = var.public_subnet_cidr_blocks[0]
  vpc_id =  aws_vpc.petclinic_vpc.id
  depends_on = [ aws_internet_gateway.petclinic_ig ]
  tags = {
    Name = "petclinic-public-SN-1"
    "kubernetes.io/role/elb" = 1
  }

}
// subnet privé dans l'az 2
resource "aws_subnet" "petclinic_private_sn_2" {
  availability_zone = var.az[1]
  map_public_ip_on_launch = false
  cidr_block = var.private_subnet_cidr_blocks[1]
  vpc_id =  aws_vpc.petclinic_vpc.id
  tags = {
    Name = "petclinic-private-SN-2"
   "kubernetes.io/role/internal-elb" = 1
  }
}
// subnet public dans l'az 2
resource "aws_subnet" "petclinic_public_sn_2" {
  
  availability_zone = var.az[1]
  map_public_ip_on_launch = true
  cidr_block = var.public_subnet_cidr_blocks[1]
  vpc_id =  aws_vpc.petclinic_vpc.id
  depends_on = [ aws_internet_gateway.petclinic_ig ]
  

  tags = {
    Name = "petcinic-public-SN-2"
    "kubernetes.io/role/elb" = 1


  }
}


 resource "aws_internet_gateway" "petclinic_ig" {
   vpc_id = aws_vpc.petclinic_vpc.id
   tags = {
     Name = "petclini-ig"
   }
 }
// associe les deux sous reseaux publics des 2 azs à IG
resource "aws_route_table" "petclinic_public_rt" {
  vpc_id = aws_vpc.petclinic_vpc.id
  tags = {
    Name = "petclinic-public-rt"
  }
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.petclinic_ig.id
  }
}

resource "aws_route_table_association" "petclinic_rt_public_1" {
  
  route_table_id = aws_route_table.petclinic_public_rt.id
  subnet_id = aws_subnet.petclinic_public_sn_1.id
}

resource "aws_route_table_association" "petclinic_rt_public_2" {
  route_table_id = aws_route_table.petclinic_public_rt.id
  subnet_id = aws_subnet.petclinic_public_sn_2.id
}

// associe le sous réseau privé au nat gateway de l' az1
/*resource "aws_route_table" "petclinic_private_rt_1" {
  vpc_id = aws_vpc.petclinic_vpc.id
  tags = {
    Name = "petclinic-private-rt-1"
  }
  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.petclinic_ng_1.id
    
  }
}

resource "aws_route_table_association" "petclinic_association_rt_private_1" {
  route_table_id = aws_route_table.petclinic_private_rt_1.id
  subnet_id = aws_subnet.petclinic_private_sn_1.id
}

// associe le sous réseau privé au  nat gateway dans l' az2  
resource "aws_route_table" "petclinic_private_rt_2" {
  vpc_id = aws_vpc.petclinic_vpc.id
  tags = {
    Name = "petclinic-private-rt-2"
  }
  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.petclinic_ng_2.id
    
  }
}

resource "aws_route_table_association" "petclinic_association_rt_private_2" {
  route_table_id = aws_route_table.petclinic_private_rt_2.id
  subnet_id = aws_subnet.petclinic_private_sn_2.id
}*/

