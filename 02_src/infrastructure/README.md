#  Infrastructure & IaC Documentation (Azure Platform)

**Owner:** Faisal (Infrastructure / Terraform / Environment Validation)  
**Project:** SIOSE — Smart Internal Operations & Support Escalation Platform  
**Team:** NEX  

---

##  Overview

This directory contains the **Infrastructure as Code (IaC)** layer responsible for provisioning the cloud host environment on **Microsoft Azure** using **Terraform**.

Terraform automates the lifecycle of all required cloud resources, network boundary security, and remote SSH access to support containerized service deployment (n8n & PostgreSQL) managed by the DevOps layer.

---

##  Architecture & Infrastructure Flow

[ Terraform IaC ] ──► [ Azure Resource Group ]
                            │
                            ├──► Virtual Network (VNet) & Subnet
                            ├──► Network Security Group (NSG Firewall)
                            ├──► Public IP Address (Static)
                            └─► Linux Virtual Machine (Ubuntu 22.04 LTS)
                                      │
                                      ▼
                             [ SSH Key Auth Access ]
                                      │
                                      ▼
                          [ DevOps Container Layer ]

---

##  Provisioned Azure Components

| Resource | Service | Description |
| :--- | :--- | :--- |
| **Resource Group** | Azure Resource Group | Isolated logical container for platform assets |
| **Networking** | Virtual Network & Subnet | Private network boundary for cloud resources |
| **Security** | Network Security Group (NSG) | Restricts SSH (22) and n8n (5678) access |
| **Compute** | Azure Linux VM | Ubuntu 22.04 LTS host running Docker Compose |
| **Public Access** | Azure Public IP | Static IP address for administrative and n8n access |

---

##  Security & Access Policies

1. **SSH Key Authentication:** Password login is disabled (`disable_password_authentication = true`). Access requires the designated SSH key (`id_ed25519`).
2. **NSG Inbound Rules:** Port 22 (SSH) is restricted to authorized admin IP addresses defined in `terraform.tfvars`.
3. **Secret Isolation:** State files (`*.tfstate`) and variable files (`terraform.tfvars`) containing credentials are strictly ignored via `.gitignore`.

---

##  Execution Commands

1. **Navigate to the Terraform Directory:**
   cd 02_src/infrastructure/terraform

2. **Initialize and Validate Infrastructure:**
   terraform init
   terraform validate

3. **Deploy Infrastructure:**
   terraform plan
   terraform apply

4. **DevOps Handoff Output:**
   After provisioning, Terraform outputs the `public_ip_address` required for SSH remote deployment and n8n service configuration.