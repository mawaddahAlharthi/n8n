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
