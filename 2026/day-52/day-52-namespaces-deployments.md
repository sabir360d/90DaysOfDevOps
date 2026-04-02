# Day 52 – Kubernetes Namespaces and Deployments

## Task
Yesterday you created standalone Pods. The problem? Delete a Pod and it is gone forever — no one recreates it. Today you fix that with Deployments, the real way to run applications in Kubernetes. You will also learn Namespaces, which let you organize and isolate resources inside a cluster.

---

## Expected Output
- At least 2 namespaces created and used
- A Deployment running with multiple replicas
- A scaled Deployment and a rolling update performed
- A markdown file: `day-52-namespaces-deployments.md`
- Screenshot of `kubectl get deployments` and `kubectl get pods` across namespaces

---

## Challenge Tasks

### Task 1: Explore Default Namespaces
Kubernetes comes with built-in namespaces. List them:

```bash
kubectl get namespaces
```

You should see at least:
- `default` — where your resources go if you do not specify a namespace
- `kube-system` — Kubernetes internal components (API server, scheduler, etc.)
- `kube-public` — publicly readable resources
- `kube-node-lease` — node heartbeat tracking

Check what is running inside `kube-system`:
```bash
kubectl get pods -n kube-system
```

These are the control plane components keeping your cluster alive. Do not touch them.

**Verify:** How many pods are running in `kube-system`?
**8**

![T1](screenshots/T1.JPG)

---

### Task 2: Create and Use Custom Namespaces
Create two namespaces — one for a development environment and one for staging:

```bash
kubectl create namespace dev
kubectl create namespace staging
```

Verify they exist:
```bash
kubectl get namespaces
```

You can also create a namespace from a manifest:
```yaml
# namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: production
```

```bash
kubectl apply -f namespace.yaml
```

Now run a pod in a specific namespace:
```bash
kubectl run nginx-dev --image=nginx:latest -n dev
kubectl run nginx-staging --image=nginx:latest -n staging
```

List pods across all namespaces:
```bash
kubectl get pods -A
```

Notice that `kubectl get pods` without `-n` only shows the `default` namespace. You must specify `-n <namespace>` or use `-A` to see everything.

**Verify:** Does `kubectl get pods` show these pods? What about `kubectl get pods -A`?
**Observation:** kubectl get pods without -n only shows the default namespace. Use -n <namespace> or -A for all.

![T2](screenshots/T2.JPG)


---

### Task 3: Create Your First Deployment
A Deployment tells Kubernetes: "I want X replicas of this Pod running at all times." If a Pod crashes, the Deployment controller recreates it automatically.

Create a file `nginx-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80
```

Key differences from a standalone Pod:
- `kind: Deployment` instead of `kind: Pod`
- `apiVersion: apps/v1` instead of `v1`
- `replicas: 3` tells Kubernetes to maintain 3 identical pods
- `selector.matchLabels` connects the Deployment to its Pods
- `template` is the Pod template — the Deployment creates Pods using this blueprint

Apply it:
```bash
kubectl apply -f nginx-deployment.yaml
```

Check the result:
```bash
kubectl get deployments -n dev
kubectl get pods -n dev
```

You should see 3 pods with names like `nginx-deployment-xxxxx-yyyyy`.

**Verify:** What do the READY, UP-TO-DATE, and AVAILABLE columns mean in the deployment output?
### Explanation:
- READY — how many pods are ready out of desired replicas
- UP-TO-DATE — number of pods updated to the latest spec
- AVAILABLE — pods available to serve traffic

![T3](screenshots/T3.JPG)

---

### Task 4: Self-Healing — Delete a Pod and Watch It Come Back
This is the key difference between a Deployment and a standalone Pod.

```bash
# List pods
kubectl get pods -n dev

# Delete one of the deployment's pods (use an actual pod name from your output)
kubectl delete pod <pod-name> -n dev

# Immediately check again
kubectl get pods -n dev
```

The Deployment controller detects that only 2 of 3 desired replicas exist and immediately creates a new one. The deleted pod is replaced within seconds.

**Verify:** Is the replacement pod's name the same as the one you deleted, or different?
- Yes, a new Pod will be created with a different name, maintaining the desired replica count.

![T4](screenshots/T4.JPG)

---

### Task 5: Scale the Deployment
Change the number of replicas:

```bash
# Scale up to 5
kubectl scale deployment nginx-deployment --replicas=5 -n dev
kubectl get pods -n dev

# Scale down to 2
kubectl scale deployment nginx-deployment --replicas=2 -n dev
kubectl get pods -n dev
```

Watch how Kubernetes creates or terminates pods to match the desired count.

You can also scale by editing the manifest — change `replicas: 4` in your YAML file and run `kubectl apply -f nginx-deployment.yaml` again.

**Verify:** When you scaled down from 5 to 2, what happened to the extra pods?
- Extra pods are terminated when scaling down.


![T5](screenshots/T5.JPG)

---

### Task 6: Rolling Update
Update the Nginx image version to trigger a rolling update:

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.25 -n dev
```

Watch the rollout in real time:
```bash
kubectl rollout status deployment/nginx-deployment -n dev
```

Kubernetes replaces pods one by one — old pods are terminated only after new ones are healthy. This means zero downtime.

Check the rollout history:
```bash
kubectl rollout history deployment/nginx-deployment -n dev
```

Now roll back to the previous version:
```bash
kubectl rollout undo deployment/nginx-deployment -n dev
kubectl rollout status deployment/nginx-deployment -n dev
```

Verify the image is back to the previous version:
```bash
kubectl describe deployment nginx-deployment -n dev | grep Image
```

**Verify:** What image version is running after the rollback?
- Rolling updates replace pods one by one without downtime. Rollback restores the previous image.

![T6](screenshots/T6.JPG)
---

### Task 7: Clean Up
```bash
kubectl delete deployment nginx-deployment -n dev
kubectl delete pod nginx-dev -n dev
kubectl delete pod nginx-staging -n staging
kubectl delete namespace dev staging production
```

Deleting a namespace removes everything inside it. Be very careful with this in production.

```bash
kubectl get namespaces
kubectl get pods -A
```

**Verify:** Are all your resources gone?
- All resources inside the deleted namespaces are removed.

![T7](screenshots/T7.JPG)

---

## Notes
## Namespaces

Namespaces isolate resources within a cluster. Useful for:

- Separating environments: dev, staging, production
- Controlling access and resource quotas
- Avoiding name collisions

## Deployments
Deployments provide:
- Self-healing: automatically recreate crashed pods
- Scaling: easily increase/decrease replicas
- Rolling updates: update images or configs with zero downtime
- Rollbacks: revert to previous versions if needed

## Commands Summary
- kubectl get <resource> -n <namespace> — resources in a namespace
- kubectl get <resource> -A — resources across all namespaces
- kubectl scale deployment <name> --replicas=N — imperative scaling
- kubectl set image deployment/<name> <container>=<image> — update image
- kubectl rollout undo deployment/<name> — rollback
- kubectl rollout history deployment/<name> — view past revisions

## Conclusion

By completing this exercise, you have learned to:

- Explore and manage namespaces
- Deploy Pods via Deployments
- Utilize self-healing, scaling, and rolling updates
- Understand the difference between standalone Pods and Deployment-managed Pods

This is the foundation for running reliable, production-ready applications on Kubernetes.
---

