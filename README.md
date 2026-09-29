# n8n

Team repository for the internal n8n workflow automation platform (SIOSE / Team NEX).

---

## Infrastructure (Faisal)

Local Infrastructure-as-Code and host validation are documented in:

[infrastructure/README.md](infrastructure/README.md)

This layer does **not** deploy n8n or PostgreSQL.  
Docker Compose remains part of the DevOps deployment layer.

---

## DevOps (Rahaf)

The DevOps layer provides the containerized deployment and lifecycle automation for the n8n platform.

Deployment files are located under:

[02_src/deployment/](./02_src/deployment/)

### Components

The deployment includes:

- n8n 2.40.6
- PostgreSQL 16
- Docker Compose
- Persistent Docker volumes
- Environment configuration template
- Bash deployment and lifecycle automation scripts

### Local Deployment

The validated local environment uses Docker Desktop with the Linux container engine.

n8n is available at:

```text
http://localhost:5678

---

## Automation Workflow (Bayan)

The automation layer provides the support ticket workflow implemented in n8n.

Workflow definition:

[02_src/n8n/support-ticket-workflow.json](02_src/n8n/support-ticket-workflow.json)

### Workflow

The workflow includes:

- IT support ticket intake
- Automatic ticket ID generation
- Category-based support team assignment
- PostgreSQL ticket storage and status updates
- 4-hour SLA monitoring
- Resolved status check
- Automatic escalation when the SLA is exceeded
- Supervisor email notification
- Reassignment and status re-check loop
- Final resolution update

### Credentials

PostgreSQL and Gmail credentials are configured securely in n8n and are not stored directly in the workflow file.