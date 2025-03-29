# EKS Infrastructure

This directory contains the Terraform configuration for creating an Amazon EKS cluster with managed node groups and custom labels.

## Infrastructure Components

### EKS Cluster
- Version: 1.29
- Public endpoint access enabled
- Cluster creator admin permissions enabled
- Automatic integration with VPC and private subnets

### Managed Node Group
- Instance type: t3.small
- Desired size: 2
- Min size: 1
- Max size: 3
- AMI: Amazon Linux 2 (AL2) x86_64
- Custom labels:
  ```yaml
  environment = "test"
  workload    = "web"
  tier        = "frontend"
  ```

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

4. Verify node labels:
   ```bash
   kubectl get nodes --show-labels
   ```

## Node Labels

The node group is configured with the following labels:
- `environment=test`: Identifies the environment
- `workload=web`: Indicates the workload type
- `tier=frontend`: Specifies the application tier

These labels can be used for:
- Node affinity rules in pod specifications
- Pod scheduling preferences
- Resource organization

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
- Node labels are automatically applied to new nodes 