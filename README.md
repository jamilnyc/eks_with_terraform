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

### Connecting and Deploying

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

### Users and Roles

#### IAM Users and Groups

A group `eks-devs` will be created with a member named `john`. You need to go into the console and create Access/Secret keys for `john`.

Then configure a profile named `john` in the AWS CLI.

```bash
aws configure --profile john
aws sts assume-role --role-arn arn:aws:iam::1234567890:role/eks-admin --role-session-name john-session --profile john
```

#### Cluster Users

```bash
# Create roles and bindings
kubectl apply -f k8s/readers-group.yaml

kubectl edit -n kube-system configmap/aws-auth
```

Add the following item under `mapRoles`, using your own role's ARN.

```yaml
- rolearn: arn:aws:iam::1234567890:role/eks-admin
  username: eks-admin
  groups:
  - system:masters
```

Then edit your `.aws/config` file to add a profile so you can assume the role

```text
[profile eks-admin]
role_arn = arn:aws:iam::1234567890:role/eks-admin
source_profile = john
```

Then update the context

```bash
aws eks update-kubeconfig --region us-east-1 --name MyAwesomeCluster --profile eks-admin
```

Confirm the `eks-admin` role is being used with 

```bash
kubectl config view --minify
```

Confirm that you have admin permissions and can execute all actions with this command. The output should be `yes`.

```bash
kubectl auth can-i "*" "*"
```