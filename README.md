# Setting up EKS with Terraform

## Prerequisites

* AWS CLI Installed (>= v2.7)
* AWS Profiled called `terraform` configured
* `kubectl` installed

## Terraform Commands

```bash
terraform init
terraform plan -out /path/to/some/file.out
terraform apply "/path/to/some/file.out"
```

## Configuration Commands

```bash
aws eks --region us-east-1 update-kubeconfig --name MyAwesomeCluster --profile terraform

# Check you can connect
kubectl get services

# Deploy
kubectl apply -f k8s/app.yaml

# Check deployment worked
kubectl get pods
kubectl get services
```