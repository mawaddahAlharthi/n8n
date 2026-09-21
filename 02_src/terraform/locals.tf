locals {
  name_prefix = "${var.project_name}-${var.environment}"

  resource_group_name = var.resource_group_name != "" ? var.resource_group_name : "rg-${local.name_prefix}"

  # Storage account names: 3–24 lowercase alphanumeric characters, globally unique.
  storage_account_name = "stn8n${var.environment}${random_id.suffix.hex}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = "Faisal Alhuthifi"
    Role        = "Infrastructure Engineer"
    ManagedBy   = "Terraform"
    Workload    = "n8n-internal-automation"
  }
}
