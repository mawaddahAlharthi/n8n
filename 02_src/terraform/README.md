# Azure Infrastructure (Terraform)

**Owner:** Faisal Alhuthifi — Infrastructure Engineer  
**Project:** Internal Workflow Automation Platform based on n8n (Project #8)  
**Tools:** Terraform, Microsoft Azure

This folder is the Infrastructure-as-Code for Azure. It creates a Resource Group, virtual network, subnet, network security group, public IP, managed disks, and a storage account.

**Team decision:** n8n is demoed locally with Docker Compose, so an Azure VM is **not** required for the demo. `vm.tf` remains in the repo if the team later deploys to Azure.

Docker, Bash install scripts, and the n8n workflow itself are **not** in this folder. Those belong to Rahaf (DevOps) and Bayan (Automation).

## What Terraform creates

```
Resource Group
 ├── Virtual Network (10.10.0.0/16)
 │    └── Subnet (10.10.1.0/24) + NSG association
 ├── Network Security Group
 │    ├── TCP 22   SSH
 │    ├── TCP 5678 n8n UI
 │    ├── TCP 80   HTTP  (optional)
 │    └── TCP 443  HTTPS (optional)
 ├── Public IP (static, Standard SKU)  — can be disabled
 ├── Network Interface
 ├── Linux VM (Ubuntu 22.04, Standard_B2s)
 │    ├── OS disk (64 GB SSD)
 │    ├── Data disk (32 GB SSD, LUN 0)
 │    └── System-assigned managed identity
 └── Storage account
      ├── n8n-backups  (private blob container)
      └── n8n-artifacts (private blob container)
```

## Prerequisites

1. An Azure subscription (student or pay-as-you-go).
2. [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) installed and on `PATH`.
3. [Terraform](https://developer.hashicorp.com/terraform/install) 1.5 or later.
4. An SSH key pair on your machine.

### Sign in to Azure

```powershell
az login
az account show
az account list --output table
# If the wrong subscription is selected:
az account set --subscription "<subscription-id-or-name>"
```

### Create an RSA SSH key (if you do not already have one)

Azure Linux VMs in this project require an **RSA** key (not Ed25519).

```powershell
ssh-keygen -t rsa -b 4096 -f $env:USERPROFILE\.ssh\id_rsa -C "n8n-platform"
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub
```

## How to deploy (repeatable)

From this directory (`02_src/terraform`):

```powershell
cd 02_src\terraform

# 1. Copy the example values and paste your public key
Copy-Item terraform.tfvars.example terraform.tfvars
notepad terraform.tfvars

# 2. Download providers
terraform init

# 3. Preview what will be created (no changes yet)
terraform plan -out=tfplan

# 4. Create the resources
terraform apply tfplan
```

`terraform apply` is **idempotent**. Running `plan` again after a successful apply should show **no changes**, which is the check from the project guidance (Step 2 expected output).

### Confirm in the Azure Portal

1. Open [portal.azure.com](https://portal.azure.com).
2. Find the resource group `b23657ba-773b-43d2-96c9-85b96f23ee6c`.
3. Confirm the VM, VNet, NSG, public IP, and storage account are present.

### Connect to the VM

Terraform prints an `ssh_command` output. Example:

```powershell
ssh azureuser@<public-ip>
```

n8n will be reachable at `http://<public-ip>:5678` **after** Rahaf’s Docker Compose stack is running. This Terraform only provisions the host.

## Restricted access

For an internal demo that should not be open to the whole internet:

```hcl
# terraform.tfvars
ssh_allowed_cidrs = ["YOUR.PUBLIC.IP.ADDR/32"]
n8n_allowed_cidrs = ["YOUR.PUBLIC.IP.ADDR/32"]
assign_public_ip  = true
```

To keep the VM private (no public IP), set `assign_public_ip = false`. You then need Azure Bastion, a VPN, or a jump host to reach it.

## Common variables

| Variable | Default | Purpose |
|---|---|---|
| `location` | `eastus` | Azure region (`westeurope`, `uaenorth`, …) |
| `vm_size` | `Standard_B2s` | 2 vCPU / 4 GiB — enough for n8n + Postgres |
| `assign_public_ip` | `true` | Attach a static public IP |
| `ssh_allowed_cidrs` | `0.0.0.0/0` | Who may SSH — restrict this |
| `n8n_port` | `5678` | NSG rule for the n8n UI |
| `data_disk_size_gb` | `32` | Extra disk at LUN 0 (`0` skips it) |

## Tear down

```powershell
terraform destroy
```

This deletes the resource group contents created by this code. It does **not** remove unrelated Azure resources.

## File map (matches Faisal’s task list)

| File | Task |
|---|---|
| `resource-group.tf` | Azure Resource Group |
| `network.tf` | Virtual network and subnet |
| `security.tf` | Network security group and access rules |
| `public-ip.tf` | Public IP and NIC (or private-only NIC) |
| `vm.tf` | Ubuntu VM that hosts the platform |
| `storage.tf` | Storage account + blob containers; OS/data disks are in `vm.tf` |
| `variables.tf` / `outputs.tf` | Inputs and values the rest of the team needs |

## Handoff to the rest of the team

After a successful apply, send Rahaf:

- SSH command / public IP (`terraform output`)
- Admin username (`azureuser` unless you changed it)
- n8n URL output (port 5678 is already open on the NSG)
- Data disk at **LUN 0** (`/dev/disk/azure/scsi1/lun0`) if they want Docker volumes on the extra disk
- Storage account name for backups
