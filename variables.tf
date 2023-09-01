variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Project Name"
  type        = string
  default     = "adroit"
}

variable "vpc_id" {
  description = "Existing VPC ID in which the resources will be deployed"
  type        = string
  default     = "vpc-0abd21e85991bfdd0"
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "adroit-example-project-vpc"
}

variable "vpc_cidr" {
  description = "Existing VPC CIDR to associate with"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "private_subnet_id" {
  description = "Private subnet ID to associate with"
  type        = string
  default     = ""
}

variable "private_subnet_ids" {
  description = "Private subnet IDs to associate with"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# RDS Databse 
################################################################################

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "abcdev123"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "abcdev123"
}

