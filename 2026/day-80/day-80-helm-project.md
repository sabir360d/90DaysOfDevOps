# Day 80: Helm Project: Multi-Environment Deployment and CI/CD

## Overview
Today I completed a production-grade Helm implementation for the AI-BankApp, covering multi-environment deployments, hooks, chart packaging, GitOps integration, and Helm best practices.

This project demonstrates how Helm enables scalable, reusable, and environment-aware Kubernetes deployments.

---

# Task 1: Environment-Specific Values (Dev, Staging, Prod)

I created three separate values files to manage environment-specific configurations without modifying the Helm chart itself.

## values-dev.yaml
```yaml
bankapp:
  replicaCount: 1
  image:
    repository: trainwithshubham/ai-bankapp-eks
    tag: "latest"
    pullPolicy: Always
  resources:
    requests:
      memory: "256Mi"
      cpu: "100m"
    limits:
      memory: "512Mi"
      cpu: "250m"
  autoscaling:
    enabled: false

mysql:
  enabled: true
  resources:
    requests:
      memory: "128Mi"
      cpu: "100m"
    limits:
      memory: "256Mi"
      cpu: "250m"
  persistence:
    size: 2Gi
    storageClass: standard

ollama:
  enabled: true
  model: tinyllama
  resources:
    requests:
      memory: "1Gi"
      cpu: "500m"
    limits:
      memory: "1.5Gi"
      cpu: "1000m"
  persistence:
    size: 5Gi
    storageClass: standard

storageClass:
  create: false
````

## values-staging.yaml

```yaml
bankapp:
  replicaCount: 2
  image:
    repository: trainwithshubham/ai-bankapp-eks
    tag: "v1.2.0"
    pullPolicy: IfNotPresent
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 3
    targetCPUUtilization: 75

mysql:
  enabled: true
  persistence:
    size: 5Gi
    storageClass: gp3

ollama:
  enabled: true
  model: tinyllama
  persistence:
    size: 10Gi
    storageClass: gp3

storageClass:
  create: true
```

## values-prod.yaml

```yaml
bankapp:
  replicaCount: 1
  image:
    repository: trainwithshubham/ai-bankapp-eks
    tag: "v1.2.0"
    pullPolicy: IfNotPresent
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 4
    targetCPUUtilization: 70

mysql:
  persistence:
    size: 20Gi
    storageClass: gp3

ollama:
  resources:
    requests:
      memory: "2Gi"
      cpu: "900m"

gateway:
  enabled: true

storageClass:
  create: true
```

## Key Observations

| Environment | Scaling     | Image Tag | Storage | Gateway |
| ----------- | ----------- | --------- | ------- | ------- |
| Dev         | 1 replica   | latest    | 2Gi     | No      |
| Staging     | HPA enabled | v1.2.0    | 5Gi     | No      |
| Prod        | HPA enabled | v1.2.0    | 20Gi    | Yes     |

---

# Task 2: Helm Hooks (Pre-Install & Tests)

## Pre-install Job Hook

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "bankapp.fullname" . }}-db-ready
  annotations:
    "helm.sh/hook": pre-install,pre-upgrade
    "helm.sh/hook-weight": "0"
    "helm.sh/hook-delete-policy": before-hook-creation
spec:
  template:
    spec:
      containers:
        - name: db-check
          image: busybox:1.36
          command:
            - /bin/sh
            - -c
            - |
              echo "Waiting for MySQL..."
              until nc -z {{ include "bankapp.fullname" . }}-mysql 3306; do
                sleep 3
              done
              echo "MySQL is ready"
      restartPolicy: Never
```

## Helm Test

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: {{ include "bankapp.fullname" . }}-test
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: test
      image: busybox:1.36
      command: ['sh', '-c', 'wget -qO- http://{{ include "bankapp.fullname" . }}-service:8080/actuator/health']
  restartPolicy: Never
```

## Commands

```bash
helm test bankapp-dev -n dev
```

---

# Task 3: Packaging and Versioning

## Lint and Package

```bash
helm lint bankapp/
helm package bankapp/
```

Output:

```
bankapp-0.1.0.tgz
```

## Version Update

```yaml
version: 0.2.0
appVersion: "1.1.0"
```

Repackage:

```bash
helm package bankapp/
```

## Helm Repository

```bash
mkdir chart-repo
cp *.tgz chart-repo/
helm repo index chart-repo/ --url https://sabir360d.github.io/helm-charts
```

## Repository Structure

```
chart-repo/
├── bankapp-0.1.0.tgz
├── bankapp-0.2.0.tgz
└── index.yaml
```

---

# Task 4: GitOps + CI/CD Integration

## Current Flow (Raw YAML)

```
Git push → GitHub Actions → build image → update YAML → ArgoCD sync
```

## Helm Flow

```
Git push → GitHub Actions → build image → update values.yaml → ArgoCD helm upgrade
```

## GitHub Actions Example

```yaml
- name: Update Helm values
  run: |
    TAG=${{ steps.tag.outputs.sha_short }}
    yq -i '.bankapp.image.tag = "'$TAG'"' helm/bankapp/values-prod.yaml
```

## ArgoCD Helm Config

```yaml
source:
  path: helm/bankapp
  helm:
    valueFiles:
      - values-prod.yaml
```

## Benefits

* Multi-environment deployments
* Version-controlled releases
* Better rollback strategy
* Native ArgoCD Helm support

---

# Task 5: Helm Best Practices

## Production Upgrade Command

```bash
helm upgrade --install bankapp-prod . \
-f values-prod.yaml \
--set bankapp.image.tag=prod-v1 \
-n prod \
--create-namespace \
--wait \
--timeout 300s \
--atomic
```

## Helm Diff Plugin

```bash
helm plugin install https://github.com/databus23/helm-diff
helm diff upgrade bankapp-prod . -f values-prod.yaml -n prod
```

## Resource Quota

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: {{ include "bankapp.fullname" . }}-quota
spec:
  hard:
    requests.cpu: "2"
    requests.memory: 4Gi
    limits.cpu: "4"
    limits.memory: 8Gi
```

## Production Notes

* Never store real secrets in values.yaml
* Use External Secrets or Vault
* Always use --atomic in production
* Always validate using helm diff

---

# Task 6: Cleanup and Final Review

## Helm Releases

```bash
helm list -A
```

## Cleanup

```bash
helm uninstall bankapp-dev -n dev
kubectl delete namespace dev
```

## Comparison of Tools

| Tool      | Use Case                 |
| --------- | ------------------------ |
| Raw YAML  | Simple deployments       |
| Helm      | Multi-env + complex apps |
| Kustomize | Patch-based overlays     |

## Key Learnings

* Helm enables environment-driven deployments
* Hooks improve deployment reliability
* GitOps integrates seamlessly with Helm
* Helm diff improves production safety
* Packaging enables chart distribution

---

# Final Outcome

I successfully built a production-ready Helm deployment system for a full-stack AI banking application with:

* Multi-environment configurations
* CI/CD integration design
* Helm hooks and testing
* Chart packaging and repository creation
* GitOps workflow design
* Production best practices

---

