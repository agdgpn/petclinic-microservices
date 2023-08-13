/*resource "aws_db_instance" "petclinic-db" {
  db_name = var.db_name
  availability_zone = var.az[0]
  engine = var.engine_name
  engine_version = var.engine_version
  password = var.db_password
  username = var.db_userName
  instance_class = var.instance_classe_name
  allocated_storage = var.db_size
  identifier = "petclinic-db"
  db_subnet_group_name = aws_db_subnet_group.petclinic_dbg.name
  vpc_security_group_ids = [aws_security_group.petclinic_sg_db.id]
  tags = {
    Name = "petclinic-db"
  }
  final_snapshot_identifier = false
}

resource "aws_db_subnet_group" "petclinic_dbg" {
  name       = "petclinic-db-group"
   subnet_ids  = [aws_subnet.petclinic_private_sn_1.id, aws_subnet.petclinic_private_sn_2.id]

  tags = {
    Name = "petclinic-db-group"
  }
}*/

