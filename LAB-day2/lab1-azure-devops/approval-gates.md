
# 🧭 **Module: DevSecOps Governance in Azure DevOps (30 Minutes)**

---

## 🎯 **Learning Objectives**

By the end of this session, participants will be able to:

1. Understand the **role of governance and approvals** in DevSecOps pipelines.
2. Implement **manual approval gates** and **audit trails** within Azure DevOps (ADO).
3. Integrate **GitHub security signals** with **ADO pipelines** (hybrid governance).
4. Use **Dependabot** and **Azure Defender for DevOps** to automate security posture checks.

---

## 🕒 **Session Breakdown**

| Segment | Duration | Topic                                               |
| ------- | -------- | --------------------------------------------------- |
| 1       | 5 mins   | Governance & approval concepts in DevSecOps         |
| 2       | 10 mins  | Configuring manual gates and audit workflows in ADO |
| 3       | 8 mins   | GitHub–ADO hybrid integration for unified security  |
| 4       | 5 mins   | Using Dependabot and Azure Defender for DevOps      |
| 5       | 2 mins   | Wrap-up discussion                                  |

---

## **1. Governance & Approvals in DevSecOps (5 mins)**

### Instructor Talking Points

> In DevSecOps, governance ensures that **security and compliance checks are not optional**, even in a continuous delivery model.
> Instead of slowing down delivery, we embed approval gates, security checks, and auditing **as code** — making compliance continuous.

### Key Concepts

* **Governance as Code** → Security and quality policies are codified in the pipeline.
* **Approval Gates** → Human validation for critical steps (e.g., prod deploy).
* **Auditable Pipelines** → Every decision, deployment, and override is logged.
* **Role-based access** → Prevents unauthorized approvals or releases.

---

## **2. Manual Approval Gates & Audit Workflows in Azure DevOps (10 mins)**

### Instructor Talking Points

> Azure DevOps provides **Environment Approvals** and **Checks** to introduce controlled release flow.
> These gates can enforce **manual approvals, security scans, or external policy checks** before deployment proceeds.

### Implementation Steps

#### 🔹 Step 1: Create Environments

1. Go to **Pipelines → Environments → New environment**.
2. Name it (e.g., `staging` or `production`).
3. Add **approval checks** under the “Approvals and Checks” tab.

#### 🔹 Step 2: Add Manual Approvers

* Click **+ Add check → Approvals**.
* Add team members or roles authorized to approve deployments.
* Optionally require comments or attach audit evidence.

#### 🔹 Step 3: Enable Audit Logs

* Navigate to **Organization Settings → Auditing**.
* Enable auditing to track pipeline executions, gate approvals, and variable changes.
* Export logs to **Azure Log Analytics** for retention or alerting.

#### 🔹 Step 4: Enforce Policy Gates (optional)

* Add **Branch policies** for PR reviews, build validation, and work item linking.
* Add **Release checks** (e.g., security scan results must be “passed” before promotion).

### Example YAML Snippet

```yaml
stages:
- stage: DeployToProd
  jobs:
  - deployment: DeployApp
    environment: production
    strategy:
      runOnce:
        deploy:
          steps:
          - script: echo "Deploying to Production..."
            displayName: "Production Deployment"
```

🔒 When linked to a protected environment with approvers, the pipeline pauses for manual approval automatically.

---

## **3. GitHub–ADO Hybrid Security Integration (8 mins)**

### Instructor Talking Points

> Many teams use GitHub for source control and Azure DevOps for CI/CD.
> Microsoft enables hybrid integration so GitHub’s **security insights** (Dependabot, CodeQL, secret scanning) feed into **ADO pipelines**.

### Integration Steps

#### 🔹 Step 1: Connect GitHub Repository

1. In ADO, create a new pipeline and choose **GitHub (YAML)** as the source.
2. Authorize the connection using a **GitHub service connection**.
3. The pipeline will automatically trigger from GitHub commits or PRs.

#### 🔹 Step 2: Surface GitHub Security Alerts in ADO

* Enable **GitHub Advanced Security** features (Dependabot, CodeQL).
* Connect GitHub → Azure DevOps via **Microsoft Defender for DevOps connector**.
* Security alerts and vulnerability insights appear in **Azure DevOps Security Hub**.

#### 🔹 Step 3: Automate Responses

* Use **Azure Policy for DevOps** to enforce:

  * Builds cannot run with critical vulnerabilities.
  * Only signed artifacts can be deployed.
* Add pipeline gates that query **Defender for DevOps APIs** for compliance checks.

---

## **4. Dependabot & Azure Defender for DevOps (5 mins)**

### **Dependabot**

Dependabot automatically scans dependencies for vulnerabilities and opens pull requests with safe version updates.

#### Enable Dependabot in GitHub

```yaml
version: 2
updates:
  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "daily"
```

**Integration Tip:**
When the GitHub repo is connected to Azure DevOps, Dependabot PRs automatically trigger pipeline builds and security tests in ADO — ensuring patched dependencies go through your normal CI/CD process.

---

### **Azure Defender for DevOps**

Azure Defender for DevOps provides **centralized visibility** and **policy enforcement** for both GitHub and Azure DevOps.

#### Features:

* Detects exposed secrets, insecure YAML pipelines, and unscanned images.
* Centralized dashboard in **Microsoft Defender for Cloud**.
* Continuous assessment of DevOps posture (identity, repo, and pipeline risk).
* Works across **GitHub**, **Azure DevOps**, and **multi-cloud repos**.

#### Activation Steps:

1. In Azure Portal, go to **Microsoft Defender for Cloud → Environment Settings**.
2. Select your subscription → Enable **Defender for DevOps**.
3. Connect Azure DevOps Organization → Repositories → Pipelines.
4. Review security recommendations under **DevOps Security Dashboard**.

---

## 🧪 **Hands-On Lab (10 mins)**

### **Lab Objective:**

Configure a pipeline with **manual approval gates**, connect it to **GitHub**, and visualize security insights in **Defender for DevOps**.

### **Lab Steps**

#### 🔹 Step 1: Create a New Pipeline

1. In Azure DevOps → **Pipelines → New Pipeline**.
2. Connect to a GitHub repo.
3. Use a simple YAML (example below):

```yaml
trigger:
  branches:
    include:
      - main

stages:
- stage: Build
  jobs:
  - job: Build
    pool:
      vmImage: 'ubuntu-latest'
    steps:
      - script: echo "Building application..."
        displayName: "Build Job"

- stage: Deploy
  dependsOn: Build
  jobs:
  - deployment: DeployWeb
    environment: staging
    strategy:
      runOnce:
        deploy:
          steps:
            - script: echo "Deploying to Staging"
              displayName: "Staging Deployment"
```

#### 🔹 Step 2: Add Manual Approval Gate

* Go to **Pipelines → Environments → staging → Approvals and Checks**.
* Add an approver (yourself or teammate).
* Run the pipeline — observe the pause for manual approval.

#### 🔹 Step 3: Enable Defender for DevOps

* In Azure Portal → **Defender for Cloud → Environment Settings → Enable Defender for DevOps**.
* Connect your Azure DevOps organization.
* Review the generated recommendations (e.g., missing branch protection, open secrets).

#### 🔹 Step 4: Enable Dependabot on GitHub

* Add `.github/dependabot.yml` to your repo as shown above.
* Trigger a PR and verify ADO builds it automatically.

---

## 🧠 **Instructor Notes & Discussion Points**

* Ask participants:

  > “How can governance enhance delivery speed instead of hindering it?”
* Highlight **“shift-governance-left”** — embedding compliance earlier in DevOps.
* Explain that **audit logs + policy enforcement** are key for **regulated industries** (finance, healthcare, government).
* Show that **hybrid security** allows teams to use **GitHub’s best developer experience** while maintaining **ADO governance and traceability**.
* Reinforce that **Dependabot + Defender for DevOps** = continuous dependency and pipeline risk management.

---

## ✅ **Summary**

| Concept                       | Description                                                                    |
| ----------------------------- | ------------------------------------------------------------------------------ |
| **Manual Approval Gates**     | Enforce human validation and compliance checks in Azure DevOps pipelines.      |
| **Audit Workflows**           | Track all pipeline runs, approvals, and environment changes for compliance.    |
| **GitHub–ADO Integration**    | Combine GitHub’s code security with Azure’s governance and deployment control. |
| **Dependabot**                | Automates dependency vulnerability remediation.                                |
| **Azure Defender for DevOps** | Provides cross-platform security posture management for pipelines and repos.   |

