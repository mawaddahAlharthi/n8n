# Internal Workflow Automation Platform (n8n)

Team project: an internal n8n automation platform.

**Team decision:** the platform is demoed **locally** with Docker. An Azure VM is not required. Faisal’s Terraform still covers Resource Group, network, NSG, public IP, and storage (those exist in Azure). The VM module is in the code for a future cloud deploy, but it is out of scope for this demo.

## Demo locally (this is the demo path)

1. Install and start [Docker Desktop](https://www.docker.com/products/docker-desktop/).
2. In PowerShell:

```powershell
cd C:\sdaproject\02_src\compose
.\start-local.ps1
```

3. Open [http://localhost:5679](http://localhost:5679) and create the owner account.
4. In n8n: **⋯ → Import from File** → `02_src\n8n\automated-ticket-workflow.json`
5. Open the workflow, click **Execute workflow** (or activate it), submit the form:
   - **Already resolved? = Yes** → ticket is stored, assigned, SLA waits 1 minute, then marked Resolved
   - **Already resolved? = No** → after the 1-minute SLA it is Escalated to supervisor  
     (production SLA would be 4 hours; 1 minute is for the live demo)

Stop:

```powershell
cd C:\sdaproject\02_src\compose
docker compose down
```

## What each person owns

| Member | Role | What to show |
|---|---|---|
| **Faisal Alhuthifi** | Infrastructure | Terraform in `02_src/terraform/` — Resource Group, network, NSG, public IP, storage. Demo host is local Docker, not an Azure VM. |
| Rahaf Almohammadi | DevOps | `02_src/compose/docker-compose.yml` starts n8n + Postgres |
| Bayan Almalawi | Automation | `02_src/n8n/automated-ticket-workflow.json` |
| Mawaddah Alharthi | DevSecOps | Docs + restrict access before any cloud deploy |

## Azure Terraform (optional — when a VM SKU is available)

See [02_src/terraform/README.md](02_src/terraform/README.md).
