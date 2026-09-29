# Platform Setup & Installation Guide

This guide provides step-by-step instructions for deploying the Internal Support Ticket Automation Platform using Terraform, Docker, and n8n on Microsoft Azure.

---

## Prerequisites
- Azure CLI installed and authenticated (`az login`)
- HashiCorp Terraform (v1.6.0+)
- SSH client & generated SSH Key pair (`id_ed25519`)
- Git

---

## Step 1: Infrastructure Provisioning (Terraform)

1. Navigate to the Terraform directory:
cd 02_src/infrastructure/terraform

2. Initialize Terraform and validate configurations:
terraform init
terraform validate

3. Copy terraform.tfvars.example to terraform.tfvars and set your Azure configuration variables:
cp terraform.tfvars.example terraform.tfvars

4. Deploy the infrastructure:
terraform plan
terraform apply

---

## Step 2: Environment & Container Deployment (Docker & n8n)

1. Access the newly created Azure Virtual Machine via SSH:
ssh -i ~/.ssh/id_ed25519 azureadmin@<VM_PUBLIC_IP>

2. Execute the environment setup and container initialization scripts:
bash 02_src/deployment/scripts/01_install_dependencies.sh
bash 02_src/deployment/scripts/02_install_docker.sh
bash 02_src/deployment/scripts/03_configure_env.sh
bash 02_src/deployment/scripts/04_start_n8n.sh

---

## Step 3: Workflow Import

1. Open your browser and navigate to: http://<VM_PUBLIC_IP>:5678
2. Set up your initial n8n admin account.
3. Select Import from File and upload 01_data/support-ticket-workflow.json.
4. Activate the imported workflow.