# Create the two VPCs
resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidr_blocks["vpc1"]
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-VPC1"
  }
}

resource "aws_vpc" "vpc2" {
  cidr_block           = var.vpc_cidr_blocks["vpc2"]
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-VPC2"
  }
}

# Create Internet Gateways
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "${var.project_name}-IGW1"
  }
}

resource "aws_internet_gateway" "igw2" {
  vpc_id = aws_vpc.vpc2.id
  tags = {
    Name = "${var.project_name}-IGW2"
  }
}

# Create Public Subnets
resource "aws_subnet" "vpc1_public" {
  count             = length(var.public_subnet_cidrs["vpc1"])
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.public_subnet_cidrs["vpc1"][count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags = {
    Name = "${var.project_name}-VPC1-Public-${count.index + 1}"
  }
}

resource "aws_subnet" "vpc2_public" {
  count             = length(var.public_subnet_cidrs["vpc2"])
  vpc_id            = aws_vpc.vpc2.id
  cidr_block        = var.public_subnet_cidrs["vpc2"][count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags = {
    Name = "${var.project_name}-VPC2-Public-${count.index + 1}"
  }
}

# Create Private Subnets
resource "aws_subnet" "vpc1_private" {
  count             = length(var.private_subnet_cidrs["vpc1"])
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.private_subnet_cidrs["vpc1"][count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags = {
    Name = "${var.project_name}-VPC1-Private-${count.index + 1}"
  }
}

resource "aws_subnet" "vpc2_private" {
  count             = length(var.private_subnet_cidrs["vpc2"])
  vpc_id            = aws_vpc.vpc2.id
  cidr_block        = var.private_subnet_cidrs["vpc2"][count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags = {
    Name = "${var.project_name}-VPC2-Private-${count.index + 1}"
  }
}

# Create Elastic IPs for NAT Gateways
resource "aws_eip" "nat1" {
  tags = {
    Name = "${var.project_name}-NAT1-EIP"
  }
}

resource "aws_eip" "nat2" {
  tags = {
    Name = "${var.project_name}-NAT2-EIP"
  }
}

# Create NAT Gateways in public subnets
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.vpc1_public[0].id
  tags = {
    Name = "${var.project_name}-NAT1"
  }
}

resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.vpc2_public[0].id
  tags = {
    Name = "${var.project_name}-NAT2"
  }
}

# Create VPC Peering Connection
resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id = aws_vpc.vpc2.id
  vpc_id      = aws_vpc.vpc1.id
  auto_accept = true
  tags = {
    Name = "${var.project_name}-Peer"
  }
}

# Create Route Tables
resource "aws_route_table" "vpc1_public" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "${var.project_name}-VPC1-Public-RT"
  }
}

resource "aws_route_table" "vpc1_private" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "${var.project_name}-VPC1-Private-RT"
  }
}

resource "aws_route_table" "vpc2_public" {
  vpc_id = aws_vpc.vpc2.id
  tags = {
    Name = "${var.project_name}-VPC2-Public-RT"
  }
}

resource "aws_route_table" "vpc2_private" {
  vpc_id = aws_vpc.vpc2.id
  tags = {
    Name = "${var.project_name}-VPC2-Private-RT"
  }
}

# Add routes to route tables
resource "aws_route" "vpc1_public_internet" {
  route_table_id         = aws_route_table.vpc1_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw1.id
}

resource "aws_route" "vpc1_private_nat" {
  route_table_id         = aws_route_table.vpc1_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat1.id
}

resource "aws_route" "vpc2_public_internet" {
  route_table_id         = aws_route_table.vpc2_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw2.id
}

resource "aws_route" "vpc2_private_nat" {
  route_table_id         = aws_route_table.vpc2_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat2.id
}

# Peering routes
resource "aws_route" "vpc1_to_vpc2" {
  route_table_id            = aws_route_table.vpc1_public.id
  destination_cidr_block    = var.vpc_cidr_blocks["vpc2"]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "vpc2_to_vpc1" {
  route_table_id            = aws_route_table.vpc2_public.id
  destination_cidr_block    = var.vpc_cidr_blocks["vpc1"]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# Associate subnets with route tables
resource "aws_route_table_association" "vpc1_public" {
  count          = length(aws_subnet.vpc1_public)
  subnet_id      = aws_subnet.vpc1_public[count.index].id
  route_table_id = aws_route_table.vpc1_public.id
}

resource "aws_route_table_association" "vpc1_private" {
  count          = length(aws_subnet.vpc1_private)
  subnet_id      = aws_subnet.vpc1_private[count.index].id
  route_table_id = aws_route_table.vpc1_private.id
}

resource "aws_route_table_association" "vpc2_public" {
  count          = length(aws_subnet.vpc2_public)
  subnet_id      = aws_subnet.vpc2_public[count.index].id
  route_table_id = aws_route_table.vpc2_public.id
}

resource "aws_route_table_association" "vpc2_private" {
  count          = length(aws_subnet.vpc2_private)
  subnet_id      = aws_subnet.vpc2_private[count.index].id
  route_table_id = aws_route_table.vpc2_private.id
}

# Create S3 VPC Endpoints
resource "aws_vpc_endpoint" "vpc1_s3" {
  vpc_id            = aws_vpc.vpc1.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.vpc1_public.id, aws_route_table.vpc1_private.id]
  tags = {
    Name = "${var.project_name}-VPC1-S3-Endpoint"
  }
}

resource "aws_vpc_endpoint" "vpc2_s3" {
  vpc_id            = aws_vpc.vpc2.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.vpc2_public.id, aws_route_table.vpc2_private.id]
  tags = {
    Name = "${var.project_name}-VPC2-S3-Endpoint"
  }
}

# Create S3 Bucket
resource "aws_s3_bucket" "central" {
  bucket = var.s3_bucket_name
  tags = {
    Name = "${var.project_name}-Central-Bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "central" {
  bucket = aws_s3_bucket.central.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Bucket policy to allow access from VPC endpoints
resource "aws_s3_bucket_policy" "central" {
  bucket = aws_s3_bucket.central.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.central.arn,
          "${aws_s3_bucket.central.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpc" = [
              aws_vpc.vpc1.id,
              aws_vpc.vpc2.id
            ]
          }
        }
      }
    ]
  })
}

# Create EC2 Instances
resource "aws_instance" "vpc1_public" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.vpc1_public[0].id
  vpc_security_group_ids      = [aws_security_group.vpc1_public.id]
  associate_public_ip_address = true
  tags = {
    Name = "${var.project_name}-VPC1-Public-Instance"
  }
}

resource "aws_instance" "vpc1_private" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.vpc1_private[0].id
  vpc_security_group_ids = [aws_security_group.vpc1_private.id]
  tags = {
    Name = "${var.project_name}-VPC1-Private-Instance"
  }
}

resource "aws_instance" "vpc2_public" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.vpc2_public[0].id
  vpc_security_group_ids      = [aws_security_group.vpc2_public.id]
  associate_public_ip_address = true
  tags = {
    Name = "${var.project_name}-VPC2-Public-Instance"
  }
}

resource "aws_instance" "vpc2_private" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.vpc2_private[0].id
  vpc_security_group_ids = [aws_security_group.vpc2_private.id]
  tags = {
    Name = "${var.project_name}-VPC2-Private-Instance"
  }
}

# CloudWatch Log Groups for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc1_flow_logs" {
  name = "/aws/vpc/${var.project_name}-VPC1/flowlogs"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "vpc2_flow_logs" {
  name = "/aws/vpc/${var.project_name}-VPC2/flowlogs"
  retention_in_days = 7
}

# IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_logs" {
  name = "${var.project_name}-VPC-Flow-Logs-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "vpc_flow_logs" {
  name = "${var.project_name}-VPC-Flow-Logs-Policy"
  role = aws_iam_role.vpc_flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

# Enable VPC Flow Logs
resource "aws_flow_log" "vpc1" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc1_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id         = aws_vpc.vpc1.id
}

resource "aws_flow_log" "vpc2" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc2_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id         = aws_vpc.vpc2.id
}

# Get latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}