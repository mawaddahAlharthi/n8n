# n8n

Team repository for the internal n8n workflow automation platform (SIOSE / Team NEX).

## Infrastructure (Faisal)

Local Infrastructure-as-Code and host validation live in [infrastructure/README.md](infrastructure/README.md).

This layer does **not** deploy n8n or PostgreSQL. Docker Compose remains the DevOps (Rahaf) layer.
````markdown
## DevOps (Rahaf)

The DevOps layer provides the containerized deployment and lifecycle automation for the n8n platform.

Deployment files are located under:

[`02_src/deployment/`](./02_src/deployment/)

### Components

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
````

PostgreSQL runs only inside the Docker network and port `5432` is not exposed externally.

### Startup

From the deployment directory:

```powershell
cd 02_src\deployment\docker
docker compose config
docker compose pull
docker compose up -d
docker compose ps
```

Then open:

```text
http://localhost:5678
```

### Deployment Validation

The following checks were completed successfully:

* Docker Compose validation
* PostgreSQL health check
* n8n startup and local access
* n8n version validation: 2.40.6
* Persistent data validation
* Redeployment validation

### Security

* The real `.env` file is excluded from Git.
* `.env.example` contains placeholders only.
* Real PostgreSQL passwords and n8n encryption keys are not stored in the repository.
* n8n is restricted to localhost access.
* PostgreSQL port `5432` is not exposed externally.

```
```
