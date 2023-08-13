variable "region" {
  default = "eu-west-3"
}
variable "cluster_name" {
  type = string
  default = "petclinic-cluster"
}
/*
 variable "db_password" {
  type = string
  sensitive = true
}
 variable "db_userName" {
   type = string
   sensitive = true
 }
*/
 variable "db_name" {
   default = "petclinic"
 }

 variable "az" {
   default = ["eu-west-3a","eu-west-3b"]
 }
 variable "engine_name" {
   default = "mysql"
 }
 variable "engine_version" {
   default= "8.0.32"
 }
 variable "id_ami" {
   default = ""
 }

 variable "instance_classe_name" {
   default = "db.t3.micro"
 }
 variable "db_size" {
   default =  20
 }
 variable "cidr_block_vpc" {
   default = "10.0.0.0/16"
 }

 variable "subnet_count" {
  type = map(number)
   default = {
    private = 2
    public = 2
   }
 }
variable "public_subnet_cidr_blocks" {
  type = list(string)
  default = [ "10.0.1.0/24",
              "10.0.2.0/24" ]
  
}
variable "private_subnet_cidr_blocks" {
  type = list(string)
  default = [ "10.0.100.0/24",
              "10.0.101.0/24"
             ]
}
 variable "vpc-name" {
   default = "petcinic-vpc "
 }
 /*
variable "access_key" {
  type= string
  sensitive = true
}
variable "secret_key" {
type = string
sensitive = true
}*/

variable "instance_type" {
  default= "t2.micro"
}

variable "jenkins_instance_type" {
  default= "t2.large"
}
variable "instance_type_cluster" {
  default = "t3.medium"
}