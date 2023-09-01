################################################################################
# RDS Instance Module
################################################################################
# There should be an RDS instance that will be used 
# for the DB backend (use MSSQL Server)

resource "aws_db_instance" "rds_db_instance" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "sqlserver-ex"    # (use MSSQL Server)
  engine_version    = "15.00.4316.3.v1" # SQL Server 2019 15.00.4316.3.v1
  instance_class    = var.instance_class
  identifier        = "my-ms-db"
  username          = var.db_username
  password          = var.db_password

  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  skip_final_snapshot    = true

  tags = var.tags
}
