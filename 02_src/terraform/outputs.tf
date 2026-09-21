output "resource_group_name" {
  description = "Azure Resource Group that holds this environment."
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Azure region of the deployment."
  value       = azurerm_resource_group.main.location
}

output "virtual_network_name" {
  description = "Virtual network name."
  value       = azurerm_virtual_network.main.name
}

output "subnet_id" {
  description = "Application subnet ID."
  value       = azurerm_subnet.app.id
}

output "network_security_group_name" {
  description = "NSG that controls inbound access to the VM."
  value       = azurerm_network_security_group.main.name
}

output "vm_name" {
  description = "Linux VM that will host n8n."
  value       = azurerm_linux_virtual_machine.main.name
}

output "vm_private_ip" {
  description = "Private IP of the n8n host."
  value       = azurerm_network_interface.main.private_ip_address
}

output "vm_public_ip" {
  description = "Public IP of the n8n host (empty when assign_public_ip is false)."
  value       = var.assign_public_ip ? azurerm_public_ip.main[0].ip_address : null
}

output "ssh_command" {
  description = "SSH command to connect to the VM after apply."
  value       = var.assign_public_ip ? "ssh ${var.admin_username}@${azurerm_public_ip.main[0].ip_address}" : "Public IP disabled — connect through a jump host or Azure Bastion using private IP ${azurerm_network_interface.main.private_ip_address}."
}

output "n8n_url" {
  description = "URL where n8n will be reachable once Docker Compose is running."
  value       = var.assign_public_ip ? "http://${azurerm_public_ip.main[0].ip_address}:${var.n8n_port}" : "http://${azurerm_network_interface.main.private_ip_address}:${var.n8n_port}"
}

output "storage_account_name" {
  description = "Storage account for boot diagnostics, backups, and artifacts."
  value       = azurerm_storage_account.main.name
}

output "backup_container_name" {
  description = "Private blob container for n8n backups."
  value       = azurerm_storage_container.backups.name
}

output "data_disk_name" {
  description = "Managed data disk attached at LUN 0 (null if data_disk_size_gb is 0)."
  value       = var.data_disk_size_gb > 0 ? azurerm_managed_disk.data[0].name : null
}
