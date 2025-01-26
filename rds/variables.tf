variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "allocated_storage" {
  description = "The size of the database (in GB)"
  default     = 20
}

variable "engine_version" {
  description = "The version of the MySQL engine"
  default     = "8.4.3"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database"
  default     = "hackatondb"
}

variable "username" {
  description = "The master username for the database"
  default     = "admin"
}

variable "password" {
  description = "The master password for the database"
  default     = "6Jqwt89TkkR"
}

variable "parameter_group_name" {
  description = "RDS parameter group name"
  default     = "default.mysql8.4"
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot on deletion"
  default     = true
}

variable "publicly_accessible" {
  description = "Whether the RDS instance should have a public IP"
  default     = true
}

variable "storage_type" {
  description = "The storage type for the RDS instance"
  default     = "gp2"
}

variable "multi_az" {
  description = "Whether the RDS instance is Multi-AZ"
  default     = false
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the RDS instance"
  default     = ["0.0.0.0/0"]
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  type        = list(string)
}
