variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  default = "CloudNet"
}

variable "vpc_cidr_blocks" {
  description = "VPCs network blocks"
  default = {
    vpc1 = "172.16.0.0/16",
    vpc2 = "172.17.0.0/16"
  }
}

variable "public_subnet_cidrs" {
  description = "Public Subnets address blocks"
  default = {
    vpc1 = ["172.16.1.0/24"],
    vpc2 = ["172.17.1.0/24"]
  }
}

variable "private_subnet_cidrs" {
  description = "Private Subnets address blocks"
  default = {
    vpc1 = ["172.16.2.0/24"],
    vpc2 = ["172.17.2.0/24"]
  }
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "instance_type" {
  default = "t3.micro"
}

variable "s3_bucket_name" {
  default = "cloudnet-bucket1"
}

variable "allowed_ssh_ips" {
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Open to the world
  }
