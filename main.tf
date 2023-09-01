provider "aws" {
  region = local.region
}
# Scenario: Adroit is looking to deploy a new microservice in our SaaS environment - 
# this will provide a new API endpoint to Adroit's SaaS clients. 

locals {
  region            = var.region
  vpc_name          = var.vpc_name
  vpc_cidr          = var.vpc_cidr
  vpc_id            = var.vpc_id
  private_subnet_id = var.private_subnet_id

  # 10.0.10.0/24 Private Subnet A, 10.0.20.0/24 Private Subnet B, 10.0.30.0/24 Private Subnet C
  private_subnet_ids = var.private_subnet_ids
  tags               = var.tags
}

# module "vpc" not needed, use existing VPC ID, CIDR, and Subnets 


################################################################################
# NLB instead of ALB, ALB does not work with VPC Endpoint
################################################################################
resource "aws_lb" "internal_nlb" {
  name               = "adroit-internal-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = local.private_subnet_ids
}

################################################################################
# VPC Endpoint
################################################################################
resource "aws_vpc_endpoint_service" "vpc_endpoint_service" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.internal_nlb.arn]
}

resource "aws_vpc_endpoint" "vpc_endpoint" {
  vpc_id             = local.vpc_id
  service_name       = "com.amazonaws.us-east-1.ec2" # Replace with the AWS service you want to access
  security_group_ids = [aws_security_group.instance.id]
  subnet_ids         = local.private_subnet_ids
  vpc_endpoint_type  = "Interface"
}

################################################################################
# Security Group
################################################################################
resource "aws_security_group" "instance" {
  name_prefix = "adroit-sg-"
  vpc_id      = local.vpc_id
  tags        = local.tags
  ingress {
    description = "443 from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.vpc_cidr # to keep it private from internet 
  }
  ingress {
    description = "7000-7010 from VPC"
    from_port   = 7000
    to_port     = 7010
    protocol    = "tcp"
    cidr_blocks = local.vpc_cidr # to keep it private from internet 
  }
}

################################################################################
# EC2 instance
################################################################################
module "ec2" {
  source            = "./modules/ec2"
  instance_count    = 1
  instance_type     = "t2.micro"
  subnet_id         = local.private_subnet_id # needs just a string.
  security_group_id = aws_security_group.instance.id
  tags              = local.tags
}

################################################################################
# RDS instance
################################################################################


module "rds" {
  source               = "./modules/rds"
  instance_class       = "db.t3.small"
  db_username          = var.db_username
  db_password          = var.db_password
  db_subnet_group_name = "default-${local.vpc_id}"
  security_group_ids   = [aws_security_group.instance.id]
  tags                 = local.tags
}




