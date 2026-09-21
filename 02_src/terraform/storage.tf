# -----------------------------------------------------------------------------
# Storage account — boot diagnostics, n8n workflow backups, and shared blobs.
# Required because storage account names must be globally unique.
# -----------------------------------------------------------------------------

resource "azurerm_storage_account" "main" {
  name                       = local.storage_account_name
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  account_tier               = "Standard"
  account_replication_type   = var.storage_replication
  account_kind               = "StorageV2"
  min_tls_version            = "TLS1_2"
  https_traffic_only_enabled = true

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = local.common_tags
}

resource "azurerm_storage_container" "backups" {
  name                  = "n8n-backups"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "artifacts" {
  name                  = "n8n-artifacts"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
