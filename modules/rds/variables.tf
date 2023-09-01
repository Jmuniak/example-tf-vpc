variable "db_username" {}
variable "db_password" {}

variable "instance_class" {
  description = "Type of EC2 instance to use"
  type        = string
  default     = "db.t3.small"
}

variable "db_subnet_group_name" {
  description = "DB Subnet Name for RDS instances"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs for EC2 instances"
  type        = list(string)
}

variable "tags" {
  description = "Tags for instances"
  type        = map
  default     = {}
}

