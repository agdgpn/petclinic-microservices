resource "aws_security_group" "petclinic_sg_ec2_public" {
  name = "petclinic-sg-ec2"
  vpc_id =  aws_vpc.petclinic_vpc.id
  
  tags = {
    Name ="petclinic-SG-ec2-public"
  }
  ingress  {
     from_port = "80"
     to_port = "80"
     cidr_blocks = ["0.0.0.0/0"]
     protocol = "tcp"
    
  }
  
  ingress  {
     from_port = "9000"
     to_port = "9000"
     cidr_blocks = ["0.0.0.0/0"]
     protocol = "tcp"
    
  }

  ingress  {
     from_port = "22"
     to_port = "22"
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }

  egress  {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    

  }

}

resource "aws_security_group" "petclinic_sg_ec2_private" {
  name = "petclinic-sg-ec2-private"
  vpc_id =  aws_vpc.petclinic_vpc.id
  
  tags = {
    Name ="petclinic-SG-ec2-private"
  }
 
  ingress  {
     from_port = "22"
     to_port = "22"
     protocol = "tcp"
    security_groups = [aws_security_group.petclinic_sg_ec2_public.id]
  }

}

resource "aws_security_group" "petclinic_sg_db" {
   name = "petclinic-sg-db"
   vpc_id =  aws_vpc.petclinic_vpc.id
   tags = {
     Name = "petclinic-sg-db"
    }
   ingress  {
    from_port = "3306"
    to_port = "3306"
    security_groups = [aws_security_group.petclinic_sg_ec2_private.id]
    protocol = "tcp"
  }
  
}

resource "aws_security_group" "petclinic_eks_cluster_sg" {
  name        = "${var.cluster_name}-security-group"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.petclinic_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-security-group"
  }
}

resource "aws_key_pair" "petclinic_key_pair" {
  key_name = "petclini_ec2_key"
  public_key = file("petclinic_kp.pub")
}