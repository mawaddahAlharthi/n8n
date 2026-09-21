# -----------------------------------------------------------------------------
# Input variables — change values in terraform.tfvars (see the example file).
# Defaults are sized for a compact internal n8n demonstration VM.
# -----------------------------------------------------------------------------

variable "project_name" {
  description = "Short name used in Azure resource names."
  type        = string
  default     = "n8n-platform"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,20}$", var.project_name))
    error_message = "project_name must be 3–20 characters of lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment tag (dev, test, or prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, prod."
  }
}

variable "location" {
  description = "Azure region for all resources (for example eastus, westeurope, uaenorth)."
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Optional explicit Resource Group name. Leave empty to auto-generate from project_name and environment."
  type        = string
  default     = ""
}

# --- Network ---

variable "vnet_address_space" {
  description = "CIDR address space for the virtual network."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "CIDR prefix for the application subnet that hosts the VM."
  type        = string
  default     = "10.10.1.0/24"
}

# --- Access control (least privilege: restrict these CIDRs before a real deployment) ---

variable "ssh_allowed_cidrs" {
  description = "Source CIDRs allowed to SSH into the VM (port 22). Replace 0.0.0.0/0 with your public IP/32 for production."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "n8n_allowed_cidrs" {
  description = "Source CIDRs allowed to reach the n8n UI and HTTP/HTTPS ports."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "n8n_port" {
  description = "TCP port where n8n will listen on the VM (Docker Compose default is 5678)."
  type        = number
  default     = 5678
}

variable "enable_http_https" {
  description = "Open ports 80 and 443 on the NSG (needed if a reverse proxy is added later)."
  type        = bool
  default     = true
}

variable "assign_public_ip" {
  description = "Attach a static public IP so the VM is reachable from the internet. Set false for restricted/internal-only access."
  type        = bool
  default     = true
}

# --- Virtual Machine ---

variable "vm_size" {
  description = "Azure VM size. Standard_B2s (2 vCPU / 4 GiB) is enough for a demo n8n stack."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Linux admin username for SSH."
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_public_key" {
  description = "RSA SSH public key (the single line from id_rsa.pub). Azure Linux VMs used here require RSA, not Ed25519."
  type        = string
  sensitive   = true

  validation {
    condition     = startswith(trimspace(var.admin_ssh_public_key), "ssh-rsa ")
    error_message = "Azure requires an RSA public key. Generate one with: ssh-keygen -t rsa -b 4096 -f $env:USERPROFILE\\.ssh\\id_rsa"
  }
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB."
  type        = number
  default     = 64
}

variable "data_disk_size_gb" {
  description = "Attached data disk size in GB for n8n/Docker persistent data. Set to 0 to skip the extra disk."
  type        = number
  default     = 32
}

variable "ubuntu_sku" {
  description = "Ubuntu Server 22.04 LTS Gen2 SKU."
  type        = string
  default     = "22_04-lts-gen2"
}

# --- Storage account ---

variable "storage_replication" {
  description = "Storage account replication type. LRS is enough for a single-region demo."
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "ZRS"], var.storage_replication)
    error_message = "storage_replication must be LRS, GRS, or ZRS."
  }
}
