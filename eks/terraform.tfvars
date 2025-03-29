project_name = "infra-k8s"
aws_region = "us-west-2"
kubernetes_version = "1.27"

node_group_desired_size = 2
node_group_max_size     = 4
node_group_min_size     = 1
node_group_instance_types = ["t3.small"]

tags = {
  Environment = "development"
  Terraform   = "true"
  Project     = "infra-k8s"
} 