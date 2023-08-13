data "aws_availability_zones" "available" {}

data "aws_ami" "petclinic_amazon_ami" {
  most_recent = true
  owners =[ "amazon"]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*" ]
  }
}

data "aws_ami" "petclinic_ubuntu_ami" {
  most_recent = true
  owners =[ "099720109477"]
  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" ]
  }
}

data "aws_ami" "petclinic_jenkins_ami" {
  most_recent = true
  owners =[ "424571028400"]
  filter {
    name = "name"
    values = [ "Jenkins-server" ]
  }
}

data "aws_eks_cluster" "petclinic_cluster" {
    name    = aws_eks_cluster.petclinic_cluster.id
}
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

