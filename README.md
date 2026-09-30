```markdown
#  Internal Support Ticket Automation Platform (n8n on Azure)

Team Repository for **Project #8: Internal Workflow Automation Platform** (SIOSE / Team NEX).

[![Azure](https://img.shields.io/badge/Provider-Microsoft%20Azure-0089D6?logo=microsoftazure)](https://azure.microsoft.com/)
[![Terraform](https://img.shields.io/badge/IaC-Terraform%20v1.6+-844FBA?logo=terraform)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Container-Docker%20Compose-2496ED?logo=docker)](https://www.docker.com/)
[![n8n](https://img.shields.io/badge/Automation-n8n%20v2.40.6-FF6D5A?logo=n8n)](https://n8n.io/)
[![Security](https://img.shields.io/badge/Security-Least%20Privilege-green)](03_docs/security-and-access.md)

An end-to-end automated internal workflow platform built to streamline IT support ticketing, enforce 4-hour SLA response monitoring, execute auto-escalations to supervisors, and record structured metadata into PostgreSQL.

---

##  Executive Summary
Manual handling of support tickets leads to delayed response times and lack of operational visibility. This solution automates the ticket lifecycle using a single-host, highly secure Azure infrastructure provisioned via Terraform, orchestrated via Docker Compose, and automated with n8n workflow pipelines.

---

##  Core Modules & Team Roles

| Module | Owner | Core Responsibilities | Quick Link |
| :--- | :--- | :--- | :--- |
| **Infrastructure** | Faisal | Azure VM, Virtual Network, NSG & Terraform IaC | [`02_src/infrastructure/`](02_src/infrastructure/) |
| **DevOps** | Rahaf | Docker Compose, PostgreSQL 16, Deployment Scripts | [`02_src/deployment/`](02_src/deployment/) |
| **Workflow** | Bayan | n8n Engine, SLA Monitoring, Auto Escalation | [`01_data/workflow.json`](01_data/support-ticket-workflow.json) |
| **Security & Docs** | Mawaddah | Security Hardening, Access Policies, Setup Guides | [`03_docs/`](03_docs/) |

---

##  Repository Layout

```text
.
├── 01_data/            # Production-ready n8n workflow JSON
├── 02_src/
│   ├── infrastructure/ # IaC Terraform definitions (Azure VM, VNet, NSG)
│   └── deployment/     # Shell deployment scripts & docker-compose.yml
├── 03_docs/            # Operational guides (Setup, Security, Troubleshooting)
├── 03_assets/          # Architectural diagrams and demo assets
└── README.md           # Master repository documentation

```

---

##  Security & Quick Setup

### Security Principles

* **Zero Hardcoded Secrets:** Environments managed via `.env` and n8n credentials.
* **SSH Key Auth Only:** Password authentication is completely disabled on the VM.
* **Git Shielding:** Sensitive states (`.tfstate`) and secrets strictly ignored in `.gitignore`.

### Quick Deployment

1. **Provision Infrastructure:**
```bash
cd 02_src/infrastructure/terraform && terraform init && terraform apply

```


2. **Deploy Stack:**
```bash
ssh -i ~/.ssh/id_ed25519 azureadmin@<VM_PUBLIC_IP>
bash 02_src/deployment/scripts/01_install_dependencies.sh
bash 02_src/deployment/scripts/04_start_n8n.sh

```


3. **Import Pipeline:**
Access `http://<VM_PUBLIC_IP>:5678` and import `01_data/support-ticket-workflow.json`.

---

##  Documentation & Validation

For detailed setup instructions, troubleshooting, and security details, refer to:

* [`03_docs/setup-guide.md`](https://www.google.com/search?q=03_docs/setup-guide.md)
* [`03_docs/security-and-access.md`](https://www.google.com/search?q=03_docs/security-and-access.md)
* [`03_docs/troubleshooting.md`](https://www.google.com/search?q=03_docs/troubleshooting.md)



