# Start the local n8n demo (Docker Desktop must be running).
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

if (-not (Test-Path ".env")) {
  Copy-Item ".env.example" ".env"
}

docker compose up -d
Write-Output ""
Write-Output "n8n is starting at http://localhost:5679"
Write-Output "First visit: create the owner account, then import 02_src\n8n\automated-ticket-workflow.json"
Write-Output "Stop later with: docker compose down"
