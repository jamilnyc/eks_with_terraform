# Setting up EKS with Terraform

## Prerequisites

* AWS CLI Installed (>= v2.7)
* AWS CLI Profile called `terraform` configured
* `kubectl` installed

## Terraform Commands

```bash
terraform init
terraform plan -out /path/to/some/file.out
terraform apply "/path/to/some/file.out"
```

This can take up to twenty minutes. Setting up the cluster and node groups takes a long time.

## Configuration Commands

```bash
# Update config with cluster information
aws eks --region us-east-1 update-kubeconfig --name MyAwesomeCluster --profile terraform

# Check you can connect
kubectl get services

# Deploy Nginx App
kubectl apply -f k8s/app.yaml

# Check deployment worked
kubectl get pods
kubectl get services
```

If the deployment was successful, you should eventually see a DNS name for both load balancers. 

It may take up to five minutes for the load balancers to become active and to eventually see the "Welcome to nginx!" page