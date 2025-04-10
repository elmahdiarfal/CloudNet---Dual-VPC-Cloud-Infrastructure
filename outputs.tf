output "vpc1_id" {
  description = "ID of VPC1"
  value       = aws_vpc.vpc1.id
}

output "vpc2_id" {
  description = "ID of VPC2"
  value       = aws_vpc.vpc2.id
}

output "vpc1_public_instance_public_ip" {
  description = "Public IP of VPC1 public instance"
  value       = aws_instance.vpc1_public.public_ip
}

output "vpc2_public_instance_public_ip" {
  description = "Public IP of VPC2 public instance"
  value       = aws_instance.vpc2_public.public_ip
}

output "s3_bucket_name" {
  description = "Name of the central S3 bucket"
  value       = aws_s3_bucket.central.bucket
}

output "vpc_peering_connection_id" {
  description = "ID of the VPC peering connection"
  value       = aws_vpc_peering_connection.peer.id
}

output "cloudwatch_log_groups" {
  description = "Names of the CloudWatch log groups for flow logs"
  value = {
    vpc1 = aws_cloudwatch_log_group.vpc1_flow_logs.name
    vpc2 = aws_cloudwatch_log_group.vpc2_flow_logs.name
  }
}