<<<<<<< HEAD
```markdown
# 🚀 Internal Support Ticket Automation Platform (n8n on Azure)

Team Repository for **Project #8: Internal Workflow Automation Platform** (SIOSE / Team NEX).

[![Azure](https://img.shields.io/badge/Provider-Microsoft%20Azure-0089D6?logo=microsoftazure)](https://azure.microsoft.com/)
[![Terraform](https://img.shields.io/badge/IaC-Terraform%20v1.6+-844FBA?logo=terraform)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Container-Docker%20Compose-2496ED?logo=docker)](https://www.docker.com/)
[![n8n](https://img.shields.io/badge/Automation-n8n%20v2.40.6-FF6D5A?logo=n8n)](https://n8n.io/)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL%2016-4169E1?logo=postgresql)](https://www.postgresql.org/)
[![Security](https://img.shields.io/badge/Security-Least%20Privilege-green)](03_docs/security-and-access.md)

An end-to-end automated internal workflow platform built to streamline IT support ticketing, enforce 4-hour SLA response monitoring, execute auto-escalations to supervisors, and record structured metadata into a relational database.

---

## 📌 Executive Summary
Manual handling of support tickets leads to delayed response times and lack of operational visibility. This solution automates the ticket lifecycle using a single-host, highly secure Azure infrastructure provisioned via Infrastructure as Code (Terraform), orchestrated via Docker Compose, and automated with n8n workflow pipelines.

---

## 📐 High-Level Architecture & Data Flow

```text
[ Form Intake / Webhook ] 
         │
         ▼
    [ n8n Engine ] ──► [ PostgreSQL Storage (Ticket Record) ]
         │
         ├──► [ Switch Routing by Category / Team ]
         │
         ├──► [ SLA 4-Hour Timer Check ] 
         │         ├─► (If Resolved): Update Database Status -> Closed
         │         └─► (If Unresolved): Auto Escalation -> Supervisor Email Notification
         │
         └──► [ Re-check Loop & Final Resolution Update ]

```

---

## ⚙️ Core Modules & Team Roles

### 1. Infrastructure (Faisal)
* Provisions host infrastructure and networking on Microsoft Azure via Terraform.
* Configures Network Security Group (NSG) isolation, Static Public IP, and VNet subnets.
* Enforces SSH Key-based authentication with disabled password login.
* Documentation: [`02_src/infrastructure/README.md`](02_src/infrastructure/README.md)

### 2. DevOps & Deployment (Rahaf)
* Orchestrates containerized deployment and lifecycle automation.
* **Tech Stack:** n8n `v2.40.6`, PostgreSQL `16`, Docker Compose, persistent Docker volumes.
* Provides environment configuration templates and automated Bash lifecycle scripts.
* Deployment Directory: [`02_src/deployment/`](02_src/deployment/)

### 3. Automation Workflow (Bayan)
* Implements end-to-end support ticket automation in n8n.
* **Features:** Automatic ticket ID generation, category-based team assignment, PostgreSQL status sync, 4-hour SLA timer, supervisor email escalation, and resolution loops.
* **Security:** PostgreSQL and Gmail credentials are securely managed in n8n credentials and never hardcoded in files.
* Workflow Definition: [`01_data/support-ticket-workflow.json`](01_data/support-ticket-workflow.json)

### 4. Security & Documentation (Mawaddah)
* Enforces Least-Privilege network restrictions, OS hardening, and secret management policies.
* Maintains strict Git exclusion policies via `.gitignore` to prevent secret leaks.
* Authored operational guides: [`03_docs/setup-guide.md`](03_docs/setup-guide.md), [`03_docs/troubleshooting.md`](03_docs/troubleshooting.md), and [`03_docs/security-and-access.md`](03_docs/security-and-access.md).

---

## 📂 Repository Layout

```text
.
├── 01_data/
│   └── support-ticket-workflow.json    # Exported production-ready n8n workflow
├── 02_src/
│   ├── infrastructure/                 # IaC Terraform definitions (Azure VM, VNet, NSG)
│   └── deployment/                     # Shell deployment scripts & docker-compose.yml
├── 03_docs/
│   ├── setup-guide.md                  # Detailed deployment steps
│   ├── troubleshooting.md              # Incident recovery & diagnostic commands
│   └── security-and-access.md          # Access control & secret management policies
├── 03_assets/                          # Architectural diagrams and demo MP4 videos
├── .gitignore                          # Strict secret exclusion rules
└── README.md                           # Master repository documentation

```

---

## 🔒 Security & Compliance Controls

* **Zero Hardcoded Secrets:** Environments and credentials managed strictly via `.env` and `n8n credentials`.
* **SSH Key Authentication:** Password login disabled (`disable_password_authentication = true`).
* **Strict Inbound NSG:** Administrative ports (SSH 22) restricted strictly to specified source CIDR blocks.
* **Git Shielding:** Local states (`.tfstate`), environment secrets (`.env`), and private keys are strictly ignored via `.gitignore`.

---

## 🚀 Quick Deployment Guide

1. **Provision Azure Infrastructure:**
```bash
cd 02_src/infrastructure/terraform
terraform init && terraform apply

```


2. **Deploy Container Environment:**
```bash
ssh -i ~/.ssh/id_ed25519 azureadmin@<VM_PUBLIC_IP>
bash 02_src/deployment/scripts/01_install_dependencies.sh
bash 02_src/deployment/scripts/04_start_n8n.sh

```


3. **Import Workflow:**
Navigate to `http://<VM_PUBLIC_IP>:5678` (or `http://localhost:5678` for local test) and import `01_data/support-ticket-workflow.json`.

---

## 📄 Deliverable Validation

Designed and validated as part of Capstone **Project #8: Internal Workflow Automation Platform**. For operational diagnostics, review [`03_docs/troubleshooting.md`](https://www.google.com/search?q=03_docs/troubleshooting.md).

```

=======
# n.8.n
>>>>>>> c4ebdb8f2df9f303672d0c0afb9af7e75a75eada
