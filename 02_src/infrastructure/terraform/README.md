# SIOSE Terraform — local infrastructure layer

**Owner:** Faisal (Infrastructure)  
**Does not own:** Docker, Docker Compose, n8n, PostgreSQL, `.env` files

This folder is Infrastructure as Code for a **local laptop**. It does not create cloud VMs and it does not start application containers.

## Why Terraform is here

The team deploys locally instead of Azure. Terraform still records the infrastructure contract and generates a non-secret handoff file for DevOps.

## Commands

From this directory:

```powershell
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
terraform plan
```

The second `plan` should report no changes.

Do **not** run `terraform destroy` unless Faisal explicitly asks for it. Destroy would only remove the generated JSON file.

## Outputs

`terraform output` prints ports, bind address, timezone, and the handoff path.  
The JSON file is written to `infrastructure/generated/infrastructure-handoff.json`.

## Providers

| Provider | Used? | Reason |
|----------|-------|--------|
| `hashicorp/local` | Yes | Writes the handoff JSON |
| `azurerm` / AWS / GCP | No | Local deployment selected by the team |
| Docker | No | Containers belong to Rahaf |

## Secrets

Never put passwords, `N8N_ENCRYPTION_KEY`, or API tokens in `.tf` files, state, or the handoff JSON.
