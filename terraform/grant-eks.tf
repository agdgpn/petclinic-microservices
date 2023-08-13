
resource "null_resource" "grant_petclinic_cluster"{

    provisioner "local-exec" {
        command="/bin/bash grant.sh ${var.aws_account_id}"
    }

    depends_on = [
        aws_eks_node_group.petclinic_node_group
    ]
}

