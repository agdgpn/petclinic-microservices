/*resource "aws_instance" "petcinic_ec2_private_1" {
    instance_type = var.instance_type
    ami = data.aws_ami.petclinic_ami.id
    availability_zone = var.az[0]
    vpc_security_group_ids = [aws_security_group.petclinic_sg_ec2_private.id]
    subnet_id = aws_subnet.petclinic_private_sn_1.id

    tags = {
      Name = "petclinic-ec2-private-1"
    }*/
//}


resource "aws_instance" "petcinic_ec2_public_1" {
    instance_type = var.instance_type
    ami = data.aws_ami.petclinic_amazon_ami.id
    availability_zone = var.az[0]
    #key_name = "petclinic_keypair"
    key_name = aws_key_pair.petclinic_key_pair.key_name
    vpc_security_group_ids = [aws_security_group.petclinic_sg_ec2_public.id]
    subnet_id = aws_subnet.petclinic_public_sn_1.id

    tags = {
      Name = "petclinic-ec2-public-1"
    }
}


// ec2 instance in az2

resource "aws_instance" "petcinic_ec2_public_2" {
    instance_type = var.jenkins_instance_type
    ami = data.aws_ami.petclinic_jenkins_ami.id
    availability_zone = var.az[1]
    #key_name = "petclinic_keypair"
    key_name = aws_key_pair.petclinic_key_pair.key_name
    vpc_security_group_ids = [aws_security_group.petclinic_sg_ec2_public.id]
    subnet_id = aws_subnet.petclinic_public_sn_2.id
    user_data              = <<-EOF
      #!/bin/bash
      sudo apt install openjdk-11-jdk-headless -y
      sudo apt update -y
      sudo apt install curl -y

      curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
        /usr/share/keyrings/jenkins-keyring.asc > /dev/null

      echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
      sudo apt update -y
      sudo apt-get install jenkins -y

      sudo systemctl start jenkins
      sudo systemctl enable --now jenkins
      # Jenkins config to set default port to 9000.
      echo "jenkins ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null
      sudo su jenkins
      sudo sed -i -e 's/Environment="JENKINS_PORT=[0-9]\+"/Environment="JENKINS_PORT=9000"/' /usr/lib/systemd/system/jenkins.service
      sudo sed -i -e 's/^\s*#\s*AmbientCapabilities=CAP_NET_BIND_SERVICE/AmbientCapabilities=CAP_NET_BIND_SERVICE/' /usr/lib/systemd/system/jenkins.service
      sudo systemctl daemon-reload
      sudo systemctl restart jenkins
      EOF

    tags = {
      Name = "Jenkins-server"
    }
}
