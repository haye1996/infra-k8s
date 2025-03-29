# EKS Infrastructure

This directory contains the Terraform configuration for creating an Amazon EKS cluster. The configuration uses the official AWS EKS module to create a production-ready Kubernetes cluster.

## Infrastructure Components

The EKS configuration includes:

- EKS Cluster with version 1.29
- Managed node group:
  - Instance type: t3.small
  - Desired size: 2
  - Min size: 1
  - Max size: 3
- Public endpoint access enabled
- Cluster creator admin permissions enabled
- Amazon Linux 2 (AL2) AMI for nodes
- Automatic integration with VPC and private subnets

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

- `cluster_id`: The ID of the EKS cluster
- `cluster_name`: The name of the EKS cluster
- `cluster_endpoint`: The endpoint of the EKS cluster
- `cluster_security_group_id`: Security group ID attached to the EKS cluster
- `cluster_iam_role_name`: IAM role name of the EKS cluster
- `cluster_iam_role_arn`: IAM role ARN of the EKS cluster
- `node_group_id`: The ID of the EKS node group
- `node_group_arn`: The ARN of the EKS node group
- `node_group_role_name`: IAM role name of the EKS node group
- `node_group_role_arn`: IAM role ARN of the EKS node group

## Dependencies

- AWS Provider (~> 5.0)
- AWS EKS Module (20.8.5)
- VPC and private subnets must exist with appropriate tags

## Notes

- The cluster is created in the us-west-2 region
- Nodes are deployed in private subnets
- The cluster uses managed node groups for better maintainability
- All necessary IAM roles and policies are automatically created 