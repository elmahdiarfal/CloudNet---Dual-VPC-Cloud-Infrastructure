# 🌐 CloudNet - Dual VPC AWS Infrastructure

![Architecture Diagram](./architecture_diagram.png)

A **Terraform** project that automates the deployment of a dual-VPC architecture on AWS, including peering, centralized storage, and monitoring features.

---

## 🚀 Features

- ✅ Two isolated VPCs (public/private subnets)
- 🔁 VPC Peering connection
- 🌐 NAT Gateways for internet access in private subnets
- 📦 Centralized S3 bucket via VPC endpoints
- 📊 VPC Flow Logs for traffic monitoring
- 🔐 Security Groups with least-privilege access
- 🌍 Highly available across multiple Availability Zones (AZs)

---

## ✅ Prerequisites

### 🔐 AWS Account
Permissions to create:
- VPCs, subnets, route tables
- EC2 instances, S3 buckets
- IAM roles and policies

### 🖥️ Local Setup
- [Terraform v1.0+](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

---

## ⚙️ Deployment Steps

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/cloudnet-dual-vpc.git
cd cloudnet-dual-vpc
```

### 2. Configure AWS credentials

Use the AWS CLI:

```bash
aws configure
```

Or set environment variables:

```bash
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_REGION="us-east-1"  # or your preferred region
```

### 3. Customize variables (optional)

Edit `variables.tf` to configure:

- VPC CIDR blocks  
- Subnet CIDRs  
- EC2 instance types  
- SSH allowed IP ranges  

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Review execution plan

```bash
terraform plan
```

### 6. Deploy the infrastructure

```bash
terraform apply
```

Type `yes` to confirm when prompted.

---

## 📦 Accessing Outputs

After deployment, Terraform will display:

- VPC IDs  
- Public EC2 instance IPs  
- S3 Bucket name  
- VPC Peering connection ID  

To view them again:

```bash
terraform output
```

---

## 💣 Destroying Infrastructure

To delete all resources:

```bash
terraform destroy
```

---

## ⚠️ Important Notes

- 💰 **Cost**: Running this infrastructure may incur **$50–100/month** in AWS charges.
- 🔐 **Security**: SSH is open to `0.0.0.0/0` by default. Update `variables.tf` for production use.
- 🧹 **Customization**: Adjust CIDR ranges in `variables.tf` to avoid overlapping with other networks.

---

## 📤 Output Examples

```bash
vpc1_id = "vpc-1234567890abcdef0"
vpc2_id = "vpc-9876543210fedcba0"
vpc1_public_instance_public_ip = "54.210.167.101"
s3_bucket_name = "cloudnet-bucket1"
```

---

## 🛠️ Troubleshooting

- **Authentication errors**: Double-check your AWS credentials and region.
- **Resource limits**: Confirm AWS account limits aren't exceeded.
- **Timeouts**: Retry or verify AWS service health.

---

## 📚 Documentation

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/)

