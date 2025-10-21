## Topic: RBAC, Network Policies, Pod Security, and Secrets Encryption

## 💻 **Hands-On Lab (15–20 Minutes)**

### **Lab 1: Create and Test RBAC Role**

```bash
kubectl create namespace dev
kubectl apply -f role.yaml
kubectl apply -f rolebinding.yaml

# Test as developer user (simulate using service account)
kubectl auth can-i delete pods -n dev --as developer1
kubectl auth can-i list pods -n dev --as developer1
```

**Expected Result:**
`delete` denied, `list` allowed ✅

---

### **Lab 2: Apply Network Policy**

1. Deploy a **frontend** and **backend** pod.
2. Apply the `deny-all.yaml` → confirm no connectivity.
3. Apply `allow-frontend-to-backend.yaml` → confirm connectivity is restored.

```bash
kubectl exec -it frontend -- curl backend:8080
```

---

### **Lab 3: Apply Pod Security Standard**

Try deploying a **privileged pod** under a `restricted` namespace label:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: privileged-pod
spec:
  containers:
  - name: busybox
    image: busybox
    securityContext:
      privileged: true
    command: ["sleep", "3600"]
```

✅ Expect the pod creation to fail under the restricted policy.

---
