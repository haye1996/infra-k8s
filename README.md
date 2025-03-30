# git --help
# aws --version
# aws configure
# terraform -help
# helm --help
# kubectl version --client

# cd into vpc folder
# terraform init
# terraform plan
# terraform apply

# cd into eks folder
# terraform init
# terraform plan
# terraform apply

# cd into app folder
# aws eks update-kubeconfig --region us-west-2 --name infra-k8s-cluster
# kubectl get all --all-namespaces

# helm install nginx-demo .
# kubectl get all --all-namespaces

# kubectl exec -it nginx-f57549dcf-8vz5l -n nginx-demo -- curl localhost

# node affinity
#  kubectl get deployment nginx -n nginx-demo -o yaml
#  kubectl get nodes --show-labels

# Clean up
# cd into app folder
# helm uninstall nginx-demo

# cd into eks folder
# terraform destroy

# cd into vpc folder
# terraform destroy

---

# Kubernetes Infrastructure with AWS EKS

This project demonstrates setting up a Kubernetes infrastructure using AWS EKS, including VPC setup, cluster configuration, and application deployment.

## High-level architecture overview
![Infra-k8s High Level Diagram](https://github.com/user-attachments/assets/ceca687a-b37f-47b1-a912-5227ad0d4b8a)

## Project Structure

```
.
├── vpc/                # VPC infrastructure
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── eks/               # EKS cluster configuration
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── app/               # Sample application
    ├── Chart.yaml
    ├── values.yaml
    └── templates/
        ├── deployment.yaml
        ├── service.yaml
        └── namespace.yaml
```

## Prerequisites

```bash
# Check required tools
git --help
aws --version
aws configure
terraform -help
helm --version
kubectl version --client
```


## Deployment Steps

### 1. VPC Setup
```bash
cd vpc
terraform init
terraform plan
terraform apply
```

### 2. EKS Cluster Setup
```bash
cd ../eks
terraform init
terraform plan
terraform apply
```

### 3. Application Deployment
```bash
cd ../app
# Configure kubectl for EKS
aws eks update-kubeconfig --region us-west-2 --name infra-k8s-cluster

# Verify cluster access
kubectl get all --all-namespaces

# Deploy application
helm install nginx-demo .

# Verify deployment
kubectl get all --all-namespaces

# Test the application
kubectl exec -it $(kubectl get pod -n nginx-demo -l app=nginx -o jsonpath='{.items[0].metadata.name}') -n nginx-demo -- curl localhost
```

## Features

### Infrastructure
- VPC with public and private subnets
- NAT Gateway for private subnet connectivity
- EKS cluster with managed node groups
- Security groups and IAM roles

### Application
- NGINX deployment with Helm
- Resource limits and requests
- Node affinity rules
- Service exposure

## Cleanup

```bash
# Remove application
cd app
helm uninstall nginx-demo

# Remove EKS cluster
cd ../eks
terraform destroy

# Remove VPC
cd ../vpc
terraform destroy
```

## Requirements

| Tool | Version |
|------|---------|
| AWS CLI | Latest |
| Terraform | >= 0.13.0 |
| Helm | Latest |
| kubectl | Latest |

## Notes
- The EKS cluster is created in us-west-2 region
- Nodes are deployed in private subnets
- Application uses Helm for deployment
- Resource limits and node affinity are configurable via values.yaml

# node affinity
#  kubectl get deployment nginx -n nginx-demo -o yaml
#  kubectl get nodes --show-labels

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
