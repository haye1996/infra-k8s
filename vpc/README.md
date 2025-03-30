# Disclaimer
This repository is for demonstration and educational purposes only. The code and documentation contained herein are not intended for commercial use without explicit approval from the repository owner. Any unauthorized commercial use is strictly prohibited.

# VPC Infrastructure

This directory contains the Terraform configuration for creating a VPC infrastructure in AWS. The configuration uses the official AWS VPC module to create a production-ready VPC with public and private subnets.

## Infrastructure Components

The VPC configuration includes:

- VPC with CIDR block 10.0.0.0/16
- 3 Availability Zones (us-west-2a, us-west-2b, us-west-2c)
- Public Subnets (10.0.4.0/24, 10.0.5.0/24, 10.0.6.0/24)
- Private Subnets (10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24)
- Internet Gateway for public subnets
- NAT Gateway for private subnets
- Route tables for both public and private subnets
- DNS hostnames enabled
- Kubernetes-specific subnet tags for EKS integration

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the planned changes:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Outputs

The configuration provides the following outputs:

- `vpc_id`: The ID of the created VPC
- `private_subnets`: List of private subnet IDs
- `public_subnets`: List of public subnet IDs

## Dependencies

- AWS Provider (~> 5.0)
- AWS VPC Module (5.8.1)

## Notes

- The VPC is configured with a single NAT Gateway for cost optimization
- Subnets are tagged for Kubernetes integration
- All resources are created in the us-west-2 region 