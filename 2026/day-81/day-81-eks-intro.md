# Day 81 -- Introduction to Amazon EKS with Terraform

# Task Overview
Transitioned the AI-BankApp from a local Kubernetes development environment (Kind) into a production-grade AWS cloud-native infrastructure using Amazon EKS and Terraform.  

The objective of this lab was to:
- Understand EKS architecture and networking
- Review and analyze Terraform-based infrastructure provisioning
- Provision a production-style EKS cluster
- Validate Kubernetes connectivity and EKS add-ons
- Deploy AI-BankApp workloads manually
- Troubleshoot real-world scheduling and infrastructure bottlenecks
- Validate persistent storage and application functionality
- Understand AWS cost optimization strategies for Kubernetes environments

Because the local machine could not support resource-heavy services such as Ollama, a remote cloud-native DevOps workstation strategy was implemented using a dedicated Ubuntu EC2 instance.

---

# Lab Environment

| Component | Details |
|---|---|
| Remote DevOps Workstation | EC2 `m7i-flex.large` |
| Workstation OS | Ubuntu |
| Workstation Specs | 2 vCPU, 8 GiB RAM, 30 GB gp3 |
| Kubernetes Platform | Amazon EKS 1.35 |
| IaC Tool | Terraform |
| Kubernetes CLI | kubectl |
| Package Manager | Helm |
| GitOps Platform | ArgoCD |
| Region | us-west-2 |

---

# Task 1: Understand EKS Architecture

## 1. What does "managed Kubernetes" mean?

Amazon EKS is AWS’s managed Kubernetes service where AWS abstracts and operates the Kubernetes control plane while engineers maintain operational responsibility over the data plane.

### AWS Manages
- Kubernetes API Server
- `etcd` distributed key-value store
- Scheduler
- Controller Managers
- Control Plane High Availability
- Multi-AZ replication
- Patching
- Kubernetes upgrades

### Engineers Manage
- Worker Nodes
- Compute sizing
- Pods and Deployments
- Persistent storage
- Horizontal scaling
- Networking policies
- Cluster workload optimization

---

# 2. EKS Components

## EKS Control Plane
The EKS control plane runs inside highly secured AWS-managed infrastructure and is exposed securely via:
- Public API Endpoint
- Private API Endpoint

The control plane consists of:
- API Server
- etcd
- Scheduler
- Controller Managers

---

## Node Groups

### Managed Node Groups
AWS automates:
- EC2 provisioning
- Rolling updates
- Node lifecycle management
- Scaling integration

### Self-Managed Nodes
Engineers manually:
- Provision EC2 instances
- Configure kubelet
- Attach nodes to clusters
- Maintain operating systems

### Fargate Profiles
Serverless Kubernetes runtime where:
- No worker nodes exist
- Pods execute on isolated AWS-managed compute environments

---

## VPC and Networking
Amazon EKS integrates deeply with native AWS VPC networking.

Features include:
- Public subnets
- Private subnets
- Intra subnets
- Multi-AZ networking
- Native pod IP allocation through AWS VPC CNI

Pods receive routable VPC IP addresses directly from AWS subnet pools.

---

## IAM Integration (IRSA)

IAM Roles for Service Accounts (IRSA) enables:
- Fine-grained AWS IAM permissions
- Pod-level cloud authentication
- Secure AWS API access without static credentials inside containers

---

# 3. EKS Add-ons Used by AI-BankApp

| Add-on | Purpose |
|---|---|
| coredns | Internal DNS and service discovery |
| kube-proxy | Kubernetes service networking |
| vpc-cni | Native AWS VPC pod IP allocation |
| eks-pod-identity-agent | Pod identity verification and IAM integration |
| aws-ebs-csi-driver | Dynamic EBS-backed persistent storage |
| metrics-server | Resource metrics collection and HPA support |

---

# Task 2: Study the AI-BankApp Terraform Configuration

## Terraform Directory Layout

```text
argocd.tf           # Installs ArgoCD using Helm
eks.tf              # Configures EKS cluster, node groups, IAM, and add-ons
outputs.tf          # Outputs helper commands and cluster access data
provider.tf         # AWS, Helm, and Kubernetes provider definitions
terraform.tfvars    # Project-specific deployment configuration values
variables.tf        # Variable declarations and type validation
vpc.tf              # Creates VPC, public/private/intra subnets, NAT Gateway
```

---

# Terraform Configuration Review

## provider.tf
Defines:
- AWS provider
- Helm provider
- Kubernetes provider
- region settings
- authentication variables

---

## variables.tf
Defines reusable infrastructure variables such as:
- cluster name
- Kubernetes version
- instance types
- node counts

---

## terraform.tfvars
Provides concrete deployment values for the infrastructure.

Original defaults:
```hcl
node_instance_type = "t3.medium"
node_desired_count = 3
node_max_count     = 5
```

Modified for cost optimization:
```hcl
node_instance_type = "t3.small"
node_desired_count = 3
node_max_count     = 3
```

---

## vpc.tf
Creates:
- VPC
- Public Subnets
- Private Subnets
- Intra Subnets
- NAT Gateway
- Internet Gateway

The networking spans 3 Availability Zones for high availability.

---

## eks.tf
Creates:
- Amazon EKS cluster
- Managed node groups
- IAM roles
- EKS add-ons
- IRSA configuration
- EBS CSI integration

---

## argocd.tf
Deploys:
- ArgoCD
- Helm-based GitOps management platform
- LoadBalancer service exposure

---

## outputs.tf
Outputs helper commands such as:
- kubeconfig update command
- ArgoCD password retrieval command

---

# EKS Architecture Diagram

```text
+-----------------------------------------------------------------------------------------------------------------------+
|                                                   AWS CLOUD (us-west-2)                                               |
|                                                                                                                       |
|  +-----------------------------------------------------------------------------------------------------------------+  |
|  |                                                VPC (10.0.0.0/16)                                                |  |
|  |                                                                                                                 |  |
|  |  +-----------------------------------------------------------------------------------------------------------+  |  |
|  |  |                                          EKS CONTROL PLANE (Managed)                                      |  |  |
|  |  |                              [ API Server ]   [ etcd Cluster ]   [ Scheduler ]                            |  |  |
|  |  +-----------------------------------------------------------------------------------------------------------+  |  |
|  |                                                     |                                                           |  |
|  |                                                     v (ENI Cross-VPC Links)                                     |  |
|  |                                                                                                                 |  |
|  |  +-----------------------------------------+ +-----------------------------------------+ +--------------------+  |  |
|  |  |        AVAILABILITY ZONE A              | |        AVAILABILITY ZONE B              | | AVAILABILITY ZONE C|  |  |
|  |  |                                         | |                                         | |                    |  |  |
|  |  |  [Public Subnet] (10.0.1.0/24)          | |  [Public Subnet] (10.0.2.0/24)          | |  [Public Subnet]   |  |  |
|  |  |   --> Internet Load Balancer            | |   --> Internet Load Balancer            | |   (10.0.3.0/24)    |  |  |
|  |  |                                         | |                                         | |                    |  |  |
|  |  |  [Intra Subnet] (10.0.7.0/24)           | |  [Intra Subnet] (10.0.8.0/24)           | |  [Intra Subnet]    |  |  |
|  |  |   --> Control Plane ENIs                | |   --> Control Plane ENIs                | |   (10.0.9.0/24)    |  |  |
|  |  |                                         | |                                         | |                    |  |  |
|  |  |  [Private Subnet] (10.0.4.0/24)         | |  [Private Subnet] (10.0.5.0/24)         | |  [Private Subnet]  |  |  |
|  |  |  ====================================== | |  ====================================== | |  (10.0.6.0/24)     |  |  |
|  |  |  MANAGED NODE GROUP (3x t3.small Nodes) | |  MANAGED NODE GROUP (3x t3.small Nodes) | |                    |  |  |
|  |  |  +-----------------------------------+  | |  +-----------------------------------+  | |  +---------------+  |  |
|  |  |  | EC2 WORKER NODE #1 (t3.small)    |  | |  | EC2 WORKER NODE #2 (t3.small)    |  | |  | WORKER NODE #3|  |  |
|  |  |  |                                   |  | |  |                                   |  | |  | (t3.small)     |  |  |
|  |  |  | Pods:                             |  | |  | Pods:                             |  | |  |               |  |  |
|  |  |  | [mysql-deployment-xxx]            |  | |  | [ollama-deployment-xxx]          |  | |  | [System Pods] |  |  |
|  |  |  |  |-- Storage: aws-ebs-csi         |  | |  |  |-- Storage: aws-ebs-csi         |  | |  |               |  |  |
|  |  |  |      |                            |  | |  |      |                            |  | |  |               |  |  |
|  |  |  |      v (Dynamic Volume Attach)    |  | |  |      v (Dynamic Volume Attach)    |  | |  |               |  |  |
|  |  |  |  (Amazon EBS Volume - 5Gi)        |  | |  |  (Amazon EBS Volume - 10Gi)       |  | |  |               |  |  |
|  |  |  |                                   |  | |  |                                   |  | |  |               |  |  |
|  |  |  | [bankapp-deployment-xxx]          |  | |  | [ArgoCD System Pods]              |  | |  |               |  |  |
|  |  |  | [System Components]               |  | |  | [Metrics Server Pods]             |  | |  |               |  |  |
|  |  |  +-----------------------------------+  | |  +-----------------------------------+  | |  +---------------+  |  |
|  |  +-----------------------------------------+ +-----------------------------------------+ +--------------------+  |  |
|  +-----------------------------------------------------------------------------------------------------------------+  |
+-----------------------------------------------------------------------------------------------------------------------+
```

---

# Task 3 & 4: Provisioning and Cluster Integration

# Cost and Footprint Optimization Strategy

To minimize AWS costs while preserving cluster functionality:
- A dedicated Ubuntu EC2 workstation was used for all DevOps tooling
- Worker node sizes were reduced from `t3.medium` to `t3.small`
- Node autoscaling ceilings were restricted

---

# Optimized Terraform Configuration

```hcl
aws_region         = "us-west-2"
cluster_name       = "bankapp-eks"
cluster_version    = "1.35"
node_instance_type = "t3.small"
node_desired_count = 3
node_max_count     = 3
```

---

# Infrastructure Initialization

```bash
terraform init
terraform plan
terraform apply --auto-approve
```

Cluster creation completed successfully in approximately 15 minutes.

---

# Configure kubectl Access

```bash
aws eks update-kubeconfig --name bankapp-eks --region us-west-2
```

---

# Validate Nodes

```bash
kubectl get nodes -o wide
```

Output confirmed:
- 3 healthy worker nodes
- multi-AZ distribution
- successful cluster registration

---

# Screenshot — EKS Worker Nodes

> Add Screenshot Here  
> `kubectl get nodes -o wide`

---

# Validate kube-system Pods

```bash
kubectl get pods -n kube-system
```

Verified:
- CoreDNS
- kube-proxy
- VPC CNI
- EBS CSI driver
- metrics-server

---

# Screenshot — kube-system Pods

> Add Screenshot Here  
> `kubectl get pods -n kube-system`

---

# ArgoCD Validation

## Verify ArgoCD Pods

```bash
kubectl get pods -n argocd
```

## Verify ArgoCD Services

```bash
kubectl get svc -n argocd
```

---

# ArgoCD Access

## Retrieve LoadBalancer URL

```bash
kubectl get svc -n argocd argocd-server \
-o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

## Retrieve Initial Admin Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 -d
```

ArgoCD was successfully exposed and accessible.

---

# Task 5: Deploy the AI-BankApp Manually

# Initial Deployment Strategy

Applying all manifests recursively initially caused:
- cert-manager related failures
- Envoy Gateway CRD dependency issues

To avoid deployment instability, manifests were applied incrementally.

---

# Manual Deployment Sequence

```bash
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/pvc.yml
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/secrets.yml
kubectl apply -f k8s/service.yml
kubectl apply -f k8s/mysql-deployment.yml
kubectl apply -f k8s/ollama-deployment.yml
kubectl apply -f k8s/bankapp-deployment.yml
kubectl apply -f k8s/hpa.yml
```

---

# Resource Scheduling Failure

The default Ollama deployment requested:

```yaml
memory: "2Gi"
```

Because `t3.small` nodes only provide 2 GiB RAM, Kubernetes could not schedule the pod.

---

# Error Encountered

```text
FailedScheduling: Insufficient memory
```

---

# Mitigation Strategy

## Reduce BankApp Replicas

```bash
kubectl scale deployment bankapp --replicas=1 -n bankapp
```

---

## Reduce Ollama Resource Requirements

```bash
sed -i 's/memory: "2Gi"/memory: "512Mi"/g' k8s/ollama-deployment.yml

sed -i 's/memory: "2.5Gi"/memory: "1.5Gi"/g' \
k8s/ollama-deployment.yml
```

---

# Re-Apply Optimized Deployment

```bash
kubectl apply -f k8s/ollama-deployment.yml
```

---

# Final Cluster Health Verification

```bash
kubectl get pods -n bankapp
```

Output:

```text
NAME                       READY   STATUS    RESTARTS   AGE
bankapp-6d69cdf947-ppg2z   1/1     Running   0          16m
bankapp-6d69cdf947-w5x7z   1/1     Running   0          23m
mysql-778d8d585d-nsgk4     1/1     Running   0          23m
ollama-7ffb7d8c5b-mw6mp    1/1     Running   0          10m
```

---

# Persistent Storage Validation

```bash
kubectl get pvc -n bankapp
kubectl get pv
```

Verified:
- 5Gi EBS volume for MySQL
- 10Gi EBS volume for Ollama model storage
- successful dynamic volume provisioning using the EBS CSI driver

---

# Screenshot — Persistent Volumes

> Add Screenshot Here  
> `kubectl get pvc -n bankapp`

---

# Application Access Verification

## Port Forwarding

```bash
kubectl port-forward --address 0.0.0.0 \
svc/bankapp-service -n bankapp 8080:8080
```

Application URL:

```text
http://<WORKSTATION_PUBLIC_IP>:8080
```

---

# Functional Validation

Verified:
- User registration
- Login workflow
- Database persistence
- Ollama-backed AI interactions
- HPA functionality

---

# Screenshot — AI-BankApp Dashboard

> Add Screenshot Here  
> AI-BankApp Running on Amazon EKS

---

# Task 6: EKS Cost Analysis and Cleanup Strategy

# Optimized Infrastructure Cost Breakdown

| Component | Approximate Cost |
|---|---|
| EKS Control Plane | ~$0.10/hr |
| 3 × t3.small Nodes | ~$0.07/hr |
| NAT Gateway | ~$0.045/hr |
| ArgoCD LoadBalancer | ~$0.025/hr |
| EBS Volumes | Minimal |
| Total | ~$0.25/hr |

---

# Why NAT Gateway Costs Are High

The NAT Gateway continuously incurs:
- hourly operational charges
- data processing charges

Even during low traffic periods.

Because worker nodes are deployed into private subnets, outbound internet traffic requires NAT traversal for:
- image pulls
- AWS API communication
- package retrieval
- cloud integrations

---

# Cleanup Procedures

## Remove Only Application Workloads

```bash
kubectl delete -f k8s/
```

---

## Destroy Entire Infrastructure

```bash
cd terraform
terraform destroy
```

This safely removes:
- EKS Cluster
- Managed Node Groups
- VPC
- NAT Gateway
- LoadBalancers
- IAM Roles
- EBS Volumes

---

# Key Learnings

- Learned Amazon EKS architecture and networking fundamentals
- Understood Terraform-based Infrastructure as Code workflows
- Provisioned a production-style Kubernetes cluster on AWS
- Configured multi-AZ networking with managed node groups
- Validated EKS add-ons and IRSA integrations
- Troubleshot Kubernetes scheduling failures in constrained environments
- Optimized workloads for low-cost AWS infrastructure
- Successfully deployed AI-BankApp with persistent EBS-backed storage
- Integrated Ollama workloads into Kubernetes under constrained resource boundaries
- Validated cluster health, HPA behavior, and storage provisioning
- Prepared the environment for future GitOps workflows using ArgoCD

---

# Final Status

| Task | Status |
|---|---|
| EKS Architecture Understanding | ✅ |
| Terraform Configuration Review | ✅ |
| EKS Provisioning | ✅ |
| kubectl Connectivity | ✅ |
| Add-ons Validation | ✅ |
| ArgoCD Installation | ✅ |
| AI-BankApp Deployment | ✅ |
| Persistent Storage Validation | ✅ |
| Cost Optimization | ✅ |
| Cleanup Strategy Understood | ✅ |

---
````

