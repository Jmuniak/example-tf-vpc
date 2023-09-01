variable "instance_count" {
  description = "Number of EC2 instances to deploy"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Type of EC2 instance to use"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet IDs for EC2 instances"
  type        = string
}

variable "security_group_id" {
  description = "Security group IDs for EC2 instances"
  type        = string
}

variable "tags" {
  description = "Tags for instances"
  type        = map
  default     = {}
}

