# Comprehensive Report

## a. High-level architecture overview
![Infra-k8s High Level Diagram](https://github.com/user-attachments/assets/ceca687a-b37f-47b1-a912-5227ad0d4b8a)

### Infrastructure Components
1. **VPC Infrastructure**
   - Public and private subnets
   - NAT Gateway for private subnet connectivity
   - Internet Gateway for public access
   - Route tables for network routing

2. **EKS Cluster**
   - Control plane (managed by AWS)
   - Managed node group with 2 nodes
   - Custom node labels for workload organization
   - Private subnet deployment for security

3. **Sample Application**
   - NGINX deployment using Helm
   - Resource limits and requests
   - Node affinity rules

## b. Reproduction Instructions

### Prerequisites
1. Required tools installed:
   ```bash
   git --help
   aws --version
   terraform -help
   helm --help
   kubectl version --client
   ```
2. AWS CLI configured with appropriate credentials
```bash
aws configure
aws configure list
```

### Deployment Steps

#### 1. VPC Setup
```bash
cd vpc
terraform init
terraform plan
terraform apply
```

#### 2. EKS Cluster Setup
```bash
cd ../eks
terraform init
terraform plan
terraform apply
```
Note: deployments of VPC and EKS cluster may take 15 to 20mins.

#### 3. Application Deployment
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

If above verification script did not work
Just manually fetch the pod name or use "kubectl get pod -n nginx-demo -l app=nginx -o jsonpath='{.items[0].metadata.name}" to fetch the pod name like "nginx-7c95dd8546-cq95d"
then do "kubectl exec -it nginx-7c95dd8546-cq95d -n nginx-demo -- curl localhost"
```

### Cleanup

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

## c. Design Choices and Tradeoffs
There is a bunch of design decisions and tradeoffs need to be made. A few examples are listed below. The purpose of this architecture is to spin up a workable EKS cluster which meets the basic business and security requriements. The apps can deploy into the cluster and new cloud resource can be added in an efficient manner. On the same time, we still keep the extensibility to further develop this architecture for production and for broader purpose.

1. **Infra Language and Tool: Terraform vs Cloudformation vs Manual scripts**
   - Choice: Terraform
   - Tradeoffs:
    - Pros: 
        - Cloud-agnostic, can manage multiple cloud providers
        - Large community and extensive module ecosystem. 
        - Great maintainability and scalability with version control againt manual scripts
        - Declarative syntax with HCL, similar to yaml, compared to cloudformation which is iterative coding. Declarative is much better for infra as code.
        - State management and dependency managemetn
    - Cons:
        - Learning curve for HCL syntax

2. **VPC Design**
   - Choice: 
     - Private subnets for EKS nodes for security, public subnets for possible introduction of load balancers
     - Subnets distributed in 3 AZs for reliability, pretty industry standard. The EKS nodes and service pods will eventually be deployed across these private subnets and AZs.


3. **EKS vs. Self-managed k8s cluster**
   - Choice: AWS EKS
   - Tradeoff: It is really about higher machine cost vs. reduced operational overhead. AWS EKS provided us a managed k8s control plane, otherwise we need to hire an additional bunch of k8s experts for that. Besides, AWS EKS have good number of add-ons like Pod Identity and AWS ALB Controller which help us integrate with other AWS cloud components.

4. **Node Group Configuration: Managed node groups vs Self-Managed Node Groups vs Karpenter**
   - Choice: Managed node groups
   - Tradeoff: To set up a easy and workable cluster with the least operation overhead, let's simply use the managed node groups rather than manually provision and deprecate EC2 instance with a self-managed node groups. But in the future, it is best to use Karpenter as it dynamically provisions EC2 instances directly based on pod requirements.

5. **Helm Chart vs custom yaml artifacts for app deployments**
   - Choice: Helm Chart
   - Tradeoffs:
     - Helm:
       - Pros:
         - Scalability!
         - Reusable components across applications
         - Standardized release management
       - Cons:
         - Additional complexity with templating syntax
         - Learning curve for Helm-specific concepts and helm templating lanague

## d. What's missing for production
To address the short-term problem and achieves the long term vision for production, we need to build a team of Cloud infra, SRE, DevOps and Security engineers.

### In the short term, we want to focus on these three areas:
1. **Immediate scalability and deployment safety**
  - Adjust the node group autoscaling limits and machines types
  - clean up the code, remove the hardcoding and lock the versions
  - store terraform state files in remote locations like DynamoDB or S3
  - Set up runbooks for deployments
2. **Security**
  - Set up QA, Staging and Prod AWS accounts
  - Grant application engineer and infrastructure engineer with different privileges to access cluster and modify infra
  - Use Pod Identity and associate one IAM Role to each k8s service account for each app or namespace with least privilege for credential isolation
3. **Observability**
  - Introduce logging tools like promethus or Datadog
  - Implement pod health checks 
  - Set up monitoring metrics and alarms

### In the long term, the goal of infrastucture team is to improve developer experience and productivity, while ensuring scalability and reliability and meet business needs.
1. **Based on business requirement, introduce cloud resource components and introduce add-ons to EKS cluster**

    For example:
  - If need data storage: introduce database instances or use AWS provided db like DynamoDB
  - If public facing web service: Introduce ELB/ALB in the public subnet, set up ingress. Introduce Route53 public DNS. For performance, possibly introduce Cloudfront.
  - If global customers: do multi-region deployments. If inter-region networking in required, configure Transit Gateway
  - If more robust node autoscaling is required: introduce Karpenter as an add-on to EKS

2. **Build a Infrastructure platform that separate infra deployments and app deployments**

    2.1. '/vpc' and '/eks' shall be moved to a different infra repo, so does other infra components introduced in future.
    - Seperate the infra repo into modules section and deployments section. Introducet tools like Terragrunt or Terraspace to orchestrate the deployments and make the code DRY.
    - Automate deployments and build GitOps workflow with tools like Spacelift or Atlantis
    
    2.2 '/app' shall be moved to a different app-infra repo, where all the service yaml helm charts and artifacts lives in.
    - Build the CI pipeline which builds the applications into Docker Image and store them in ECR or Dockerhub
    - Build the GitOps CD pipeline which leverage tools like Gitlabs or ArgoCD  to deployment apps to EKS.
