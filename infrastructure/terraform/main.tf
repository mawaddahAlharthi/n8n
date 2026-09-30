# ---------------------------------------------------------------------------
# Local infrastructure definition
#
# Why this file exists:
#   The team demos SIOSE on local devices. Azure/AWS/GCP/Kubernetes are
#   out of scope. Terraform is still required as Infrastructure as Code.
#
# What this configuration DOES:
#   - Records the local infrastructure contract (ports, exposure, timezone)
#   - Generates a NON-SECRET JSON handoff for Rahaf (DevOps)
#
# What this configuration does NOT do:
#   - Create n8n containers
#   - Create PostgreSQL containers
#   - Manage Docker Compose
#   - Open firewall ports
#   - Destroy anything
#
# Safe workflow:
#   terraform fmt
#   terraform init
#   terraform validate
#   terraform plan
#   terraform apply
# ---------------------------------------------------------------------------

locals {
  # Azure is intentionally unused. Keep this string in outputs/docs so the
  # infrastructure-to-DevOps handoff does not invent cloud resources.
  azure_status = "NOT APPLICABLE — Local deployment selected by team"

  generated_dir = abspath("${path.module}/../generated")

  handoff = {
    environment_type             = var.environment_type
    application                  = var.application
    team                         = var.team
    deployment_model             = var.deployment_model
    timezone                     = var.timezone
    n8n_internal_port            = var.n8n_internal_port
    n8n_host_port                = var.n8n_host_port
    n8n_bind_address             = var.n8n_bind_address
    n8n_public_internet_exposure = false
    postgres_internal_port       = var.postgres_internal_port
    postgres_external_exposure   = var.postgres_external_exposure
    postgres_network             = "docker-internal"
    azure                        = local.azure_status
    notes = [
      "Terraform owns infrastructure requirements and this handoff file.",
      "Docker Compose owns n8n and PostgreSQL. Do not convert those services into Terraform resources.",
      "If host port 5678 is busy, DevOps may publish 5679:5678. Update n8n_host_port in terraform.tfvars and re-apply. Do not change the container port.",
      "PostgreSQL must stay on the Docker internal network only."
    ]
  }
}

# Non-secret metadata only. Never write passwords, tokens, or encryption keys.
resource "local_file" "infrastructure_handoff" {
  filename = "${local.generated_dir}/${var.handoff_filename}"
  content  = jsonencode(local.handoff)

  # Windows does not apply Unix file modes. Ignoring these attributes keeps
  # the second `terraform plan` stable (no perpetual permission diffs).
  lifecycle {
    ignore_changes = [file_permission, directory_permission]
  }
}
