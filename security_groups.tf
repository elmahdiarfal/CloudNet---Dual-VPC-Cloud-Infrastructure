# Security Group for Public Instances in VPC1
resource "aws_security_group" "vpc1_public" {
  name        = "${var.project_name}-VPC1-Public-SG"
  description = "Allow SSH and HTTP/HTTPS inbound traffic"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "SSH from allowed IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_ips
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-VPC1-Public-SG"
  }
}

# Security Group for Private Instances in VPC1
resource "aws_security_group" "vpc1_private" {
  name        = "${var.project_name}-VPC1-Private-SG"
  description = "Allow internal traffic only"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "All traffic from VPC1"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_blocks["vpc1"]]
  }

  ingress {
    description = "All traffic from VPC2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_blocks["vpc2"]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-VPC1-Private-SG"
  }
}

# Security Group for Public Instances in VPC2
resource "aws_security_group" "vpc2_public" {
  name        = "${var.project_name}-VPC2-Public-SG"
  description = "Allow SSH and HTTP/HTTPS inbound traffic"
  vpc_id      = aws_vpc.vpc2.id

  ingress {
    description = "SSH from allowed IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_ips
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-VPC2-Public-SG"
  }
}

# Security Group for Private Instances in VPC2
resource "aws_security_group" "vpc2_private" {
  name        = "${var.project_name}-VPC2-Private-SG"
  description = "Allow internal traffic only"
  vpc_id      = aws_vpc.vpc2.id

  ingress {
    description = "All traffic from VPC2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_blocks["vpc2"]]
  }

  ingress {
    description = "All traffic from VPC1"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_blocks["vpc1"]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-VPC2-Private-SG"
  }
}