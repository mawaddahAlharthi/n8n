# Infrastructure evidence — Faisal

Collect this evidence for the capstone report and the DevOps handoff.

Take screenshots of **commands and their output**. Do not open or photograph:

- `docker/.env` or any `.env`
- `terraform.tfvars`
- `*.tfstate`
- passwords, tokens, private keys, `N8N_ENCRYPTION_KEY`

Suggested folder on your machine (not in git unless the screenshot contains no secrets): keep copies next to your report.

## 1. Host / environment

| Evidence | Command or action | Screenshot of |
|----------|-------------------|----------------|
| Operating system | `winver` or `Get-CimInstance Win32_OperatingSystem` | Windows edition and version |
| Hostname | `hostname` | `DESKTOP-...` |
| CPU architecture | `$env:PROCESSOR_ARCHITECTURE` | `AMD64` |
| CPU / cores | Task Manager → Performance, or `Get-CimInstance Win32_Processor` | cores / logical processors |
| RAM | Task Manager → Performance → Memory | total RAM |
| Disk | Explorer → C: properties, or `Get-CimInstance Win32_LogicalDisk` | free space |

## 2. Tool versions

Run in PowerShell. Screenshot each command with its output:

```powershell
terraform version
docker version
docker compose version
git --version
bash --version
wsl -l -v
```

## 3. Terraform workflow

Working directory: `infrastructure/terraform`

```powershell
cd C:\n8n\infrastructure\terraform
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
terraform plan
```

| Step | Expected evidence |
|------|-------------------|
| `fmt` | No errors (files already formatted, or Terraform rewrites them) |
| `init` | Providers installed successfully |
| `validate` | `Success! The configuration is valid.` |
| first `plan` | Will create the local handoff JSON (before apply) |
| `apply` | `Apply complete!` and a `local_file` created |
| second `plan` | `No changes. Your infrastructure matches the configuration.` |

Screenshot the **second plan**. That is the idempotency evidence.

Do not screenshot `terraform destroy`. Do not run destroy unless asked.

## 4. Generated handoff (non-secret)

Open `infrastructure/generated/infrastructure-handoff.json`.

Screenshot the JSON. It must show ports and `postgres_external_exposure: false`.  
It must **not** contain passwords.

## 5. Networking / ports

```powershell
Get-NetTCPConnection -LocalPort 5678,5432 -State Listen -ErrorAction SilentlyContinue
```

Also include the port lines from the validation script.

## 6. Infrastructure validation

```powershell
powershell -ExecutionPolicy Bypass -File C:\n8n\infrastructure\scripts\check-infrastructure.ps1
```

Screenshot the full `[PASS]` / `[WARNING]` / `[FAIL]` output and the final `Infrastructure status` line.

Optional (WSL / Git Bash):

```bash
./infrastructure/scripts/check-infrastructure.sh
```

## 7. Docker availability (not a deploy)

These prove Docker exists. They are **not** Rahaf’s deployment evidence.

```powershell
docker info
docker compose version
```

Do **not** run `docker compose up` as Faisal’s infrastructure evidence.

## Checklist before submitting

- [ ] Terraform version
- [ ] terraform fmt / init / validate / plan / apply
- [ ] Second terraform plan (no changes)
- [ ] OS, CPU, RAM, disk
- [ ] Docker + Compose available
- [ ] Port 5678 and 5432 results
- [ ] Validation script output
- [ ] Handoff JSON (no secrets)
- [ ] Azure labelled NOT APPLICABLE
