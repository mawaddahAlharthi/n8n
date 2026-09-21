# Unique suffix so storage account names stay globally unique across applies
# in different subscriptions, while remaining stable for a given state file.

resource "random_id" "suffix" {
  byte_length = 4
}

# -----------------------------------------------------------------------------
# Azure Resource Group — container for every resource in this environment.
# -----------------------------------------------------------------------------

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}
