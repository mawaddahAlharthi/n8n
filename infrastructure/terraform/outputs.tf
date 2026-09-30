# ---------------------------------------------------------------------------
# Outputs — copy these into the infrastructure-to-DevOps handoff.
# No secret values are exported.
# ---------------------------------------------------------------------------

output "environment_type" {
  description = "Deployment environment. Always local for this project."
  value       = var.environment_type
}

output "application" {
  description = "Application name."
  value       = var.application
}

output "team" {
  description = "Team name."
  value       = var.team
}

output "deployment_model" {
  description = "Application deployment method owned by DevOps."
  value       = var.deployment_model
}

output "timezone" {
  description = "Required timezone."
  value       = var.timezone
}

output "n8n_internal_port" {
  description = "n8n port inside the container."
  value       = var.n8n_internal_port
}

output "n8n_host_port" {
  description = "Host port that should reach n8n. Confirm with the validation script before asking DevOps to change it."
  value       = var.n8n_host_port
}

output "n8n_bind_address" {
  description = "Recommended bind address for n8n on the host (localhost only)."
  value       = var.n8n_bind_address
}

output "postgres_internal_port" {
  description = "PostgreSQL port on the Docker internal network."
  value       = var.postgres_internal_port
}

output "postgres_external_exposure" {
  description = "Must be false. PostgreSQL is not published."
  value       = var.postgres_external_exposure
}

output "azure" {
  description = "Azure is not used."
  value       = local.azure_status
}

output "handoff_file" {
  description = "Path to the generated non-secret DevOps handoff file."
  value       = local_file.infrastructure_handoff.filename
}

output "devops_action_required" {
  description = "What Rahaf should do with this infrastructure contract."
  value       = "Start n8n and PostgreSQL with Docker Compose. Publish n8n as ${var.n8n_bind_address}:${var.n8n_host_port}->${var.n8n_internal_port}. Do not publish PostgreSQL port ${var.postgres_internal_port}."
}
