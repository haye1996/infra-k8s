# Disclaimer
This repository is for demonstration and educational purposes only. The code and documentation contained herein are not intended for commercial use without explicit approval from the repository owner. Any unauthorized commercial use is strictly prohibited.

# Preparation
1. Have access to an environment where you can launch and terminate new hosts programmatically
# Tasks
1. Kubernetes Cluster Setup:
a. Set up a multi-node Kubernetes cluster (control plane + data plane)
i. You're not expected to build a production-ready cluster — but you should document what would be needed to get there.
ii. It is ok to use lightweight distribution like kubeadm, k3s or k0s
b. Automate the set up process with good infra practice
2. Deploy a Sample Application
a. Choose a simple app (NGINX).
b. Define:
Helm chart
Resource requests and limits
Node affinity
2. Documentation:
a. Thoroughly document the design and outline potential areas for future enhancement.
# Deliverables
1. GitHub Repository✅:
a. Submit a GitHub repository containing all the code utilized for the tasks.

2. Comprehensive Report✅:
a. High-level architecture overview (diagram included)
b. Reproduction instructions (how to spin up the cluster)
c. Design choices and tradeoffs
d. What's missing for production

3. Recording showing✅:
a. Cluster is up and running
b. Nodes are registered
c. App is successfully deployed