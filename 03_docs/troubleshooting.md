# System Operations & Troubleshooting Guide

This document outlines standard troubleshooting protocols and diagnostic commands for maintaining system health.

---

## Common Issues & Recovery Procedures

### 1. n8n Container or Web Interface Unreachable
- Symptom: Unable to open http://<VM_PUBLIC_IP>:5678.
- Diagnostic Command: Check container statuses on the VM:
docker ps -a

- Resolution Step: If n8n or PostgreSQL is stopped, restart services using the redeploy script:
bash 02_src/deployment/scripts/06_redeploy.sh

---

### 2. Database Connection Failure
- Symptom: Workflow logs indicate PostgreSQL connection refused.
- Diagnostic Command: Inspect container logs:
docker logs n8n_postgres_container

- Resolution Step: Ensure .env contains matching credentials and verify postgres service health:
bash 02_src/deployment/scripts/05_health_check.sh

---

### 3. SSH Connection Denied to Azure VM
- Symptom: Connection timed out or Permission denied (publickey).
- Diagnostic Step: Verify that your current Public IP matches the admin_source_cidr defined in terraform.tfvars.
- Resolution Step: Update your IP in terraform.tfvars and run:
terraform apply