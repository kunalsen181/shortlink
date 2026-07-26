# 🚀 End-to-End DevOps CI/CD Pipeline on AWS using Terraform, Ansible, Jenkins, Docker & Kubernetes (K3s)

An end-to-end DevOps project demonstrating complete Infrastructure as Code (IaC), Configuration Management, Continuous Integration, Continuous Deployment, Containerization, Kubernetes orchestration, and Monitoring.

The project provisions AWS infrastructure using Terraform, configures the server using Ansible, builds and deploys a multi-container application through Jenkins CI/CD, and monitors the Kubernetes cluster using Prometheus and Grafana.

---

# 📌 Project Architecture

![Architecture](docs/project-architecture.png)

---

# 🚀 Tech Stack

### Cloud
- AWS EC2
- AWS EBS
- AWS VPC
- Subnet
- Internet Gateway
- Route Tables
- Security Groups

### Infrastructure as Code
- Terraform

### Configuration Management
- Ansible

### CI/CD
- Jenkins
- GitHub Webhook

### Containerization
- Docker
- Docker Hub

### Container Orchestration
- Kubernetes (K3s)

### Monitoring
- Prometheus
- Grafana

### Application Stack
- Frontend (Nginx)
- Backend (Flask)
- PostgreSQL
- Redis

---

# 📂 Project Structure

```text
aws-jenkins-k3s
│
├── ansible/
│   ├── inventory/
│   ├── playbooks/
│   ├── roles/
│   └── ansible.cfg
│
├── app/
│   ├── backend/
│   ├── frontend/
│   ├── docker-compose.yml
│   └── Jenkinsfile
│
├── jenkins/
│   └── Jenkinsfile
│
├── kubernetes/
│   ├── backend.yaml
│   ├── frontend.yaml
│   ├── db.yaml
│   ├── cache.yaml
│   ├── ingress.yaml
│   └── kind-config.yaml
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── providers.tf
│   ├── outputs.tf
│   ├── inventory.tpl
│   └── terraform.tfvars
│
├── docs/
│   └── project-architecture.png
│
└── README.md
```

---

# ⚙️ CI/CD Workflow

```text
Developer
      │
      ▼
Git Push
      │
      ▼
GitHub Repository
      │
      ▼
GitHub Webhook
      │
      ▼
Jenkins Pipeline
      │
      ├── Checkout Source Code
      ├── Build Docker Images
      ├── Push Images to Docker Hub
      └── Deploy to Kubernetes (kubectl apply)
                │
                ▼
          K3s Kubernetes Cluster
                │
        ┌───────┼────────┐
        ▼       ▼        ▼
   Frontend  Backend   Database
                       Redis
```

---

# 📊 Monitoring

Prometheus continuously scrapes metrics from the Kubernetes cluster.

Grafana uses Prometheus as its data source to visualize:

- CPU Usage
- Memory Usage
- Disk Usage
- Node Health
- Kubernetes Cluster Metrics
- Running Pods
- System Performance

---

# 🔨 Infrastructure Provisioning

Terraform provisions:

- VPC
- EBS
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance
- SSH Key Pair

---

# ⚙️ Server Configuration

Ansible automates:

- Docker Installation
- K3s Installation
- Jenkins Installation
- Required Packages
- System Configuration

---

# 🐳 Docker

The application is containerized into:

- Frontend Image
- Backend Image

Docker images are pushed to Docker Hub before deployment.

---

# ☸️ Kubernetes Deployment

Application components running inside K3s:

- Frontend (Nginx)
- Backend (Flask)
- PostgreSQL
- Redis

Kubernetes resources include:

- Deployments
- Services
- Ingress

---

# 📈 Jenkins Pipeline

Pipeline Stages:

1. Checkout Repository
2. Build Docker Images
3. Push Images to Docker Hub
4. Deploy to Kubernetes
5. Verify Deployment

The pipeline is automatically triggered using a **GitHub Webhook** whenever new code is pushed.

---

# 🛠️ Features

- Infrastructure as Code using Terraform
- Automated Server Configuration using Ansible
- Jenkins CI/CD Pipeline
- GitHub Webhook Integration
- Docker Image Build & Push
- Kubernetes Deployment
- Ingress Configuration
- Prometheus Monitoring
- Grafana Dashboard
- Fully Automated Deployment Workflow



# 📚 Skills Demonstrated

- AWS
- Terraform
- Ansible
- Jenkins
- GitHub Webhooks
- Docker
- Docker Hub
- Kubernetes (K3s)
- CI/CD
- Infrastructure as Code
- Monitoring
- DevOps Automation

---

# 👨‍💻 Author

**Kunal Sen**
