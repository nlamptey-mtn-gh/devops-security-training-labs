**Steps to Install ArgoCD on an AKS (Kubernetes) Cluster**

1. **Create the ArgoCD Namespace**  
   Create a dedicated namespace for ArgoCD by running:
   ```
   kubectl create namespace argocd
   ```

2. **Install ArgoCD in the Namespace**  
   Deploy ArgoCD in the `argocd` namespace using the official manifest:
   ```
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

3. **Verify ArgoCD Installation**  
   Check that the ArgoCD resources have been created successfully:
   ```
   kubectl get all -n argocd
   ```

4. **Expose the ArgoCD API Server**  
   Update the `argocd-server` service to use a LoadBalancer, making it accessible from the internet:
   ```
   kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
   ```

5. **Retrieve the LoadBalancer Public IP and Port**  
   Obtain the external IP and port for accessing the ArgoCD UI:
   ```
   kubectl get svc -n argocd
   ```

6. **Access ArgoCD and Retrieve the Initial Admin Password**  
   - Open the ArgoCD UI in your browser using the external IP and port.
   - The default username is `admin`.
   - Get the initial admin password with:
     ```
     kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
     ```
