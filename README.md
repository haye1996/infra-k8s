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

