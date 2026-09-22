# ---------------------------------------------------------------------------
# Terraform and provider versions
#
# This configuration describes LOCAL infrastructure requirements only.
# It must remain runnable on a student laptop without cloud credentials.
# ---------------------------------------------------------------------------

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    # Writes a non-secret handoff file for the DevOps layer.
    # No Azure, AWS, GCP, Kubernetes, or Docker providers.
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
