
# Lab Scripts**

These labs are designed to reinforce secure pipeline practices.

---

## **Lab 1: Implement Least Privilege & Secrets**

### **Goal**

Create a secure Azure DevOps pipeline that deploys an app using **Key Vault secrets** and **scoped permissions**.

### **Steps**

```bash
# 1. Create Service Principal with restricted role
az ad sp create-for-rbac \
  --name "ado-deploy-sp" \
  --role "WebAppContributor" \
  --scopes /subscriptions/<SUB_ID>/resourceGroups/<RG_NAME>

# 2. Store credentials in Key Vault
az keyvault secret set --vault-name secure-kv-prod --name "sp-client-id" --value "<CLIENT_ID>"
az keyvault secret set --vault-name secure-kv-prod --name "sp-client-secret" --value "<CLIENT_SECRET>"
```

**Pipeline YAML:**

```yaml
trigger:
  branches:
    include:
      - main

variables:
- group: 'prod-variables'
- name: 'keyVaultName'
  value: 'secure-kv-prod'

stages:
- stage: Deploy
  displayName: "Deploy to Azure"
  jobs:
  - job: DeployWeb
    steps:
    - task: AzureKeyVault@2
      inputs:
        azureSubscription: 'AzureServiceConnection'
        KeyVaultName: '$(keyVaultName)'
        SecretsFilter: '*'

    - script: echo "Deploying app using secrets from Key Vault"
```

✅ **Verification:** Pipeline runs successfully and fetches secrets securely.

---

## **Lab 2: Add Approvals and Checks**

### **Goal**

Protect your Production environment with manual approvals.

### **Steps**

1. Go to **Pipelines → Environments → Add new environment → Production**.
2. Under **Approvals and checks**, add approvers (e.g., `SecurityLead@company.com`).
3. Update YAML:

```yaml
stages:
- stage: DeployProd
  displayName: 'Deploy to Production'
  jobs:
  - deployment: DeployWeb
    environment: 'Production'
    strategy:
      runOnce:
        deploy:
          steps:
          - script: echo "Deploying production build..."
```

✅ **Verification:** Deployment pauses for manual approval.

---

## **Lab 3: Automate Dependency and Vulnerability Scanning**

### **Goal**

Enable Dependabot and integrate Trivy scan in ADO.

### **Steps**

```yaml
steps:
- task: dependabot@1
  inputs:
    packageManager: 'npm'
    targetBranch: 'main'
    openPullRequestsLimit: 5

- script: |
    echo "Running container vulnerability scan..."
    trivy image myregistry.azurecr.io/myapp:$(Build.BuildId)
  displayName: 'Run Trivy Scan'
```

✅ **Verification:**

* Dependabot opens PRs for outdated or vulnerable dependencies.
* Trivy report identifies vulnerabilities in the build log.

---

## **Lab Summary Checklist**

| Control              | Configured | Verified |
| -------------------- | ---------- | -------- |
| Least Privilege      | ✅          | ✅        |
| Secret Management    | ✅          | ✅        |
| Approvals & Checks   | ✅          | ✅        |
| Dependency Scanning  | ✅          | ✅        |
| Vulnerability Alerts | ✅          | ✅        |

---

## **Wrap-Up Discussion**

* How would you enforce these policies across all teams?
* What automation could fail builds with high-risk CVEs?
* Can Azure Policy or Defender for DevOps complement these controls?

---

Would you like me to create a **PowerPoint slide deck** (around 10–12 slides) from these notes — suitable for your training delivery?
