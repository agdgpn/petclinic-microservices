resource "aws_iam_role" "petclinic_cluster_iam_role" {
  name = "petclinic-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

}

resource "aws_iam_role_policy_attachment" "petclinic_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.petclinic_cluster_iam_role.name
}

resource "aws_eks_cluster" "petclinic_cluster" {
    name = var.cluster_name
    vpc_config {
      subnet_ids = [aws_subnet.petclinic_public_sn_1.id,aws_subnet.petclinic_public_sn_2.id]
    }
  role_arn = aws_iam_role.petclinic_cluster_iam_role.arn
  depends_on = [
    aws_iam_role_policy_attachment.petclinic_AmazonEKSClusterPolicy  ]

  /*  provisioner "remote-exec" {
    inline = [ 
      "helm repo add traefik https://helm.traefik.io/traefik",
      "helm repo update",
      "helm install traefik traefik/traefik --create-namespace --namespace=traefik --values=values.yaml",
#      "kubectl apply -f middleware.yml",
    ]
  }*/
  


}

resource "aws_eks_node_group" "petclinic_node_group" {
  cluster_name    = aws_eks_cluster.petclinic_cluster.name
  node_group_name = "petclini-NG"
  node_role_arn   = aws_iam_role.petclinic_eks_node_group_role.arn
  subnet_ids      = [aws_subnet.petclinic_public_sn_1.id,aws_subnet.petclinic_public_sn_2.id]
  /*launch_template {
  name = aws_launch_template.petclinic_eks_launch_template.name
  version = aws_launch_template.petclinic_eks_launch_template.latest_version
}*/
  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 2
      }
    instance_types  = [var.instance_type_cluster]

  update_config {
    max_unavailable = 1
  }
  tags = {
    Name = "petclinic-NG"
    "kubernetes.io/cluster/cluster-name"= "owned"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.petclinic_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.petclinic_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.petclinic_AmazonEC2ContainerRegistryReadOnly,
    
  ]
  provisioner "local-exec" {
    #interpreter = ["/bin/bash", "-c"]
    command="/bin/bash grant.sh"

    }
     
  /*provisioner "local-exec" {
    #interpreter = ["/bin/bash", "-c"]
    command="/bin/bash install_traefik.sh"
    }*/
}

resource "aws_iam_role" "petclinic_eks_node_group_role" {
  name = "petclinic-eks-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "petclinic_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.petclinic_eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "petclinic_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.petclinic_eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "petclinic_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.petclinic_eks_node_group_role.name
}


/*resource "kubernetes_config_map" "aws-auth" {
  data = {
    "mapRoles" = <<EOT
- rolearn: arn:aws:iam::424571028400:role/petclinic-eks-node-group
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
	
	EOT
    "mapUsers" = <<EOT
- userarn: arn:aws:iam::424571028400:user/pndiaye
  username: pndiaye
  groups:
   - system:bootstrappers
   - system:masters
- userarn: arn:aws:iam::424571028400:user/dgregoire
  username: dgregoire
  groups:
   - system:bootstrappers
   - system:masters
EOT
  }

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}*/

