# GCP Microservices Application Deployment with Terraform, ArgoCD, and CI/CD Pipeline

## Project Overview

This project automates the deployment of a **microservices application** on a **GKE (Google Kubernetes Engine) cluster** using a fully automated and secure CI/CD pipeline. It leverages multiple GCP services to ensure a robust and scalable environment.

### **Key Technologies and Services Used:**

- **Terraform:** Infrastructure as Code (IaC) to provision GCP resources including:
- GKE cluster and node pools.
- VPC network and subnet configurations.
- GCP Secret Manager for managing sensitive credentials.
- GCS Bucket with versioning enabled to store Terraform state securely.
- **ArgoCD:** Continuous Delivery (CD) to manage and sync Kubernetes applications from GitHub.
- **GitHub Actions CI/CD Pipelines:**
- `deploy.yml` → Deploys the full microservices stack and infrastructure.
- `cleanup.yml` → Destroys the GKE cluster and cleans up all associated resources.
- **External Secrets Operator:** Syncs Kubernetes secrets from GCP Secret Manager.
- **Prometheus and Grafana:** Monitors application performance and sends real-time alerts.
- **Alertmanager for Notifications:**
- Sends **alerts to Slack and Email** for critical incidents.
- Tracks **Pod Down/Up** and **Node Down/Up** alerts.
- **Cert-Manager with Let's Encrypt:** Manages TLS certificates to secure ingress traffic.

---

## Folder Structure

```
.
├── .github/
│   └── workflows/
│       ├── deploy.yml         # CI/CD pipeline for deployment
│       └── cleanup.yml        # CI/CD pipeline for cleanup
├── argocd-manifest/
│   ├── cert-manager.yml
│   ├── encrypt.yml
│   ├── gcp-microsvc-project.yml
│   ├── grafana.yml
│   ├── ingress.yml
│   ├── microsvc.yml
│   ├── nginx-ingress.yml
│   └── prometheus-app.yml
├── encrypt-chart/
│   └── clusterissuer.yml
├── ingress-chart/
│   ├── ingress-argocd.yml
│   ├── ingress-monitoring.yml
│   └── ingress.yml
├── microsvc-chart/
│   ├── deployment.yaml
│   ├── namespace.yaml
│   └── service.yaml
├── prometheus-chart/
│   ├── chart.yaml
│   └── values/
│       └── prometheus-values.yml
├── terraform_code/
│   ├── backend.tf
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   └── variables.tf
├── alertmanager-external-secret.yml
└── gcp-cluster-secret-store.yml
```

---

## ⚡️ CI/CD Workflow Breakdown

### **Deployment Pipeline: `deploy.yml`**

The deployment pipeline automates the following steps:

1. **Authenticate to GCP** using service account credentials.
2. **Initialize Terraform** to provision GCP resources:
   - GKE cluster, node pools, IAM roles, and VPCs.
3. **Get GKE Cluster Credentials** to interact with the Kubernetes API.
4. **Install External Secrets Operator** using Helm to manage secrets.
5. **Create GCP Secret Manager Keys** and apply Kubernetes secrets.
6. **Install ArgoCD** to manage Kubernetes resources.
7. **Deploy Microservices and Infrastructure** via ArgoCD manifests.

---

### **Cleanup Pipeline: `cleanup.yml`**

The cleanup pipeline automates:

1. **Authenticate to GCP** and get GKE credentials.
2. **Delete ArgoCD Applications** to prevent reconciliation conflicts.
3. **Wait for 60 seconds** to allow Kubernetes resources to finalize.
4. **Destroy Terraform Infrastructure** to clean up GCP resources.

---

## Microservices Deployment Flow

1. **Terraform Deploys GKE Cluster**

   - Creates a secure VPC and provisions a GKE cluster.
   - Configures IAM roles and grants necessary permissions.

2. **ArgoCD Manages Microservices and Ingress**

   - `microsvc-chart/` handles app deployment.
   - `ingress-chart/` configures ingress for app and monitoring.
   - `encrypt-chart/` installs cert-manager for TLS/SSL.

3. **Prometheus and Grafana Monitoring Setup**

   - `prometheus-app.yml` deploys Prometheus with custom values.
   - `grafana.yml` deploys Grafana for visualization.

4. **External Secrets Fetches Secrets from GCP Secret Manager**
   - `alertmanager-external-secret.yml` fetches and mounts secrets.
   - `gcp-cluster-secret-store.yml` defines secret storage config.

---

## Alerting with Alertmanager

### **Notification Destinations:**

- **Email:** Alerts sent for critical incidents.
- **Slack:** Sends real-time alerts to a dedicated Slack channel.

### **Configured Alert Rules:**

- **PodDown/PodUp Alerts:**
- Alerts when a pod goes down or recovers.
- Monitors pod readiness status.
- **NodeDown/NodeUp Alerts:**
- Detects when a node becomes unavailable.
- Sends recovery notification when the node is back up.

Alerts are configured in `alerting_rules.yml` as part of the Prometheus chart.

---

## Key Technologies Used

- **Terraform** – Infrastructure as Code (IaC)
- **ArgoCD** – GitOps Continuous Delivery (CD)
- **GKE (Google Kubernetes Engine)** – Cluster Orchestration
- **External Secrets Operator** – Secret Management
- **Prometheus & Grafana** – Monitoring and Visualization
- **Alertmanager** – Notifications to Slack and Email
- **GitHub Actions** – CI/CD Automation

---

## Prerequisites

- Google Cloud Project with billing enabled.
- Service Account with `Editor` and `Kubernetes Admin` permissions.
- Add these secrets to GitHub:
  - `GCP_SA_KEY` → Service Account Key JSON
  - `GCP_PROJECT_ID` → GCP Project ID
  - `GKE_NAME` → Name of the GKE cluster
  - `GKE_ZONE` → Zone where the cluster is deployed
  - `GKE_REGION` → GCP Region for the cluster
  - `GKE_ACCOUNT_ID` → Service Account ID

---

## Usage Instructions

### **Clone the Repository:**

```bash
git clone https://github.com/busybrainx99/GCP_Microsvc_App.git
cd GCP_Microsvc_App
```

### **Configure Secrets for GitHub Actions:**

- Go to your GitHub repo.
- Navigate to:  
  `Settings` → `Secrets and variables` → `Actions` → `New repository secret`

Add the following secrets:

- `GCP_SA_KEY`
- `GCP_PROJECT_ID`
- `GKE_NAME`
- `GKE_ZONE`
- `GKE_REGION`
- `GKE_ACCOUNT_ID`

---

## **Deploy Microservices**

To run the deployment workflow manually:

```bash
gh workflow run deploy.yml
```

Or push to the `main` branch to trigger automatically or Manually trigger the workflow in the actions tab. (if enabled):

```bash
git push origin main
```

---

## **Cleanup Infrastructure**

To destroy the cluster and clean up all resources:

```bash
gh workflow run cleanup.yml
```

Or Manually trigger the workflow in the actions tab. (if enabled)

---

## Application Details

### **Encryption and Cert-Manager**

- Manages certificates and enables TLS for ingress resources.
- Uses `cert-manager` and `letsencrypt` via Helm.

### **Monitoring with Prometheus and Grafana**

- Prometheus monitors microservices metrics and alerts.
- Grafana visualizes cluster and application data.

### **Kubernetes Manifests Managed by ArgoCD**

- ArgoCD syncs and manages all Kubernetes resources.
- Applications defined in `argocd-manifest/` for:
  - `microsvc` → Microservices Deployment
  - `cert-manager` → Cluster Issuer Setup
  - `prometheus-app` → Monitoring and Alerting
  - `grafana` → Dashboard Visualization
  - `nginx-ingress` → Routing and Load Balancing

---

## To Do / Improvements

- Add notification alerts for CI/CD pipeline success/failure.
- Configure Helm hooks for rolling upgrades and zero downtime.
- Add horizontal pod autoscaling (HPA) to improve scalability.

---

## Why This Project Is Relevant for DevOps/Cloud Roles

This project demonstrates:

- Expertise in **Kubernetes, Helm, and Terraform.**
- Proficiency in setting up **GitOps with ArgoCD.**
- Mastery of **CI/CD pipelines using GitHub Actions.**
- Knowledge of **Cloud Infrastructure Management in GCP.**
- Implementation of **Monitoring, Alerting, and Security Best Practices.**

---

## Contact / Connect

If you’d like to connect or collaborate, feel free to:

- 📧 Email: [ebohgoodness.t@gmail.com](mailto:ebohgoodness.t@gmail.com)
- 🔗 LinkedIn: [Goodness E. Eboh](https://www.linkedin.com/in/goodness-eboh)
- 🔗 X: [Goodness](https://https://x.com/busybrainx99)

---

**This project showcases advanced DevOps practices, Cloud Infrastructure automation, and CI/CD pipelines, making it a perfect addition to your portfolio for Cloud/DevOps roles!**
