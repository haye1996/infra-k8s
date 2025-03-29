# brew tap hashicorp/tap
# brew install hashicorp/tap/terraform
# terraform -help
# terraform init
# terraform plan
# terraform apply

# brew install kubectl
# aws eks update-kubeconfig --name infra-k8s-cluster --region us-west-2
# kubectl get pods -n kube-system
# kubectl get all --all-namespaces

# AWS VPC and EKS Infrastructure

This project contains Terraform modules to create a VPC with public and private subnets, and deploy an EKS cluster in AWS.

## Project Structure

```
.
├── main.tf              # Main configuration file
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── modules/
│   ├── vpc/            # VPC module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   └── eks/            # EKS module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
└── README.md
```

## Features

### VPC Module
- Creates a VPC with DNS support
- 2 public subnets
- 2 private subnets
- Internet Gateway
- NAT Gateway
- Route tables for public and private subnets
- Route table associations

### EKS Module
- Creates an EKS cluster
- Managed node group
- Required IAM roles and policies
- Security groups

## Usage

1. Initialize Terraform:
```bash
terraform init
```

2. Create a `terraform.tfvars` file with your values:
```hcl
project_name = "my-project"
aws_region   = "us-west-2"
vpc_cidr     = "10.0.0.0/16"

availability_zones = ["us-west-2a", "us-west-2b"]

kubernetes_version = "1.27"

node_group_desired_size = 2
node_group_max_size     = 4
node_group_min_size     = 1
node_group_instance_types = ["t3.medium"]

tags = {
  Environment = "production"
  Terraform   = "true"
}
```

3. Plan the changes:
```bash
terraform plan
```

4. Apply the changes:
```bash
terraform apply
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 5.0 |
| kubernetes | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region to deploy resources | string | "us-west-2" | no |
| project_name | Name of the project, used as a prefix for all resources | string | n/a | yes |
| vpc_cidr | CIDR block for the VPC | string | "10.0.0.0/16" | no |
| availability_zones | List of availability zones | list(string) | ["us-west-2a", "us-west-2b"] | no |
| kubernetes_version | Kubernetes version to use for the EKS cluster | string | "1.27" | no |
| node_group_desired_size | Desired number of worker nodes | number | 2 | no |
| node_group_max_size | Maximum number of worker nodes | number | 4 | no |
| node_group_min_size | Minimum number of worker nodes | number | 1 | no |
| node_group_instance_types | List of instance types for the node group | list(string) | ["t3.medium"] | no |
| tags | A map of tags to add to all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| public_subnet_ids | List of public subnet IDs |
| private_subnet_ids | List of private subnet IDs |
| cluster_id | The ID of the EKS cluster |
| cluster_name | The name of the EKS cluster |
| cluster_endpoint | The endpoint for the EKS cluster |
| cluster_security_group_id | Security group ID attached to the EKS cluster |
| node_group_id | The ID of the EKS node group |
| node_group_arn | The ARN of the EKS node group |