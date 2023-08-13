terraform {
  required_providers {
    aws={
        source = "hashicorp/aws"
        version = "~>5.0"
    }
    kubernetes={
      source = "hashicorp/kubernetes"
      version = "2.22.0"
}
    }
  }

provider "aws" {
  region = "eu-west-3"
  #access_key = var.access_key
  #secret_key = var.secret_key
}

/*provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.petclinic_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.petclinic_cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.petclinic_cluster.name]
      command     = "aws"
    }
  }
}*/


provider "kubernetes" {
  host                   = data.aws_eks_cluster.petclinic_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.petclinic_cluster.certificate_authority[0].data)
  token                  = data.aaws_eks_cluster.petclinic_cluster.token
}