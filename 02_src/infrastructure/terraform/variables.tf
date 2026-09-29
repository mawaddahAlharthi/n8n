# ---------------------------------------------------------------------------
# Input variables — machine-specific values belong in terraform.tfvars
# (gitignored). Defaults match the team's local Docker Compose design.
#
# Terraform does NOT create n8n or PostgreSQL containers.
# Those remain Rahaf's DevOps / Docker Compose responsibility.
# ---------------------------------------------------------------------------

variable "environment_type" {
  description = "Where the platform runs. This project uses local laptops, not Azure."
  type        = string
  default     = "local"

  validation {
    condition     = var.environment_type == "local"
    error_message = "This Terraform configuration only supports environment_type = \"local\"."
  }
}

variable "application" {
  description = "Application name used in handoff metadata."
  type        = string
  default     = "SIOSE"
}

variable "team" {
  description = "Team name used in handoff metadata."
  type        = string
  default     = "NEX"
}

variable "deployment_model" {
  description = "How the application stack is started. Compose stays in the DevOps layer."
  type        = string
  default     = "docker-compose"

  validation {
    condition     = var.deployment_model == "docker-compose"
    error_message = "deployment_model must be docker-compose. Terraform must not replace Compose."
  }
}

variable "timezone" {
  description = "IANA timezone for n8n schedules and host alignment."
  type        = string
  default     = "Asia/Riyadh"
}

variable "n8n_internal_port" {
  description = "Container-side n8n listen port. Docker Compose must keep this at 5678."
  type        = number
  default     = 5678

  validation {
    condition     = var.n8n_internal_port == 5678
    error_message = "n8n_internal_port must remain 5678 inside the container."
  }
}

variable "n8n_host_port" {
  description = "Host port published to the browser. Default 5678. If occupied, DevOps may map 5679:5678 instead — report that to Rahaf; do not edit Compose from Terraform."
  type        = number
  default     = 5678
}

variable "n8n_bind_address" {
  description = "Recommended host bind address. Localhost only — do not expose n8n to the public internet."
  type        = string
  default     = "127.0.0.1"
}

variable "postgres_internal_port" {
  description = "PostgreSQL port on the Docker internal network."
  type        = number
  default     = 5432

  validation {
    condition     = var.postgres_internal_port == 5432
    error_message = "postgres_internal_port must remain 5432."
  }
}

variable "postgres_external_exposure" {
  description = "Whether PostgreSQL is published on the host or internet. Must stay false."
  type        = bool
  default     = false

  validation {
    condition     = var.postgres_external_exposure == false
    error_message = "PostgreSQL must not be published. Keep postgres_external_exposure = false."
  }
}

variable "handoff_filename" {
  description = "Non-secret JSON file consumed by the DevOps handoff. No passwords or keys."
  type        = string
  default     = "infrastructure-handoff.json"
}
