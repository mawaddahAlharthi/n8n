# Security Controls & Access Policy Documentation

## 1. Secret Management Policy
- No Plain-Text Credentials: Credentials, API tokens, and passwords are fully encapsulated within .env files and n8n environment variables.
- Git Protections: .env and terraform.tfvars are explicitly ignored via .gitignore to prevent secret leaks to public/private repositories.

## 2. Least Privilege & Network Isolation
- SSH Access Control: Port 22 is restricted to specific administrator IP addresses via Azure Network Security Group (NSG) rules.
- Password Authentication Disabled: OS access enforces SSH Key authentication (disable_password_authentication = true).

## 3. Container Isolation
- n8n and PostgreSQL services run within an isolated Docker network bridge, exposing only necessary operational ports (5678).