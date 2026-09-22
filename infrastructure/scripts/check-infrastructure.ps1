# check-infrastructure.ps1
# Faisal / Infrastructure — host prerequisite validation only.
#
# This is NOT a deployment script.
# It does not install Docker, start Compose, change firewall rules,
# or stop processes.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\infrastructure\scripts\check-infrastructure.ps1

$ErrorActionPreference = "Continue"
$FailCount = 0
$WarnCount = 0

function Write-Pass([string]$Message) {
    Write-Host "[PASS]    $Message"
}

function Write-Warn([string]$Message) {
    Write-Host "[WARNING] $Message"
    $script:WarnCount++
}

function Write-Fail([string]$Message) {
    Write-Host "[FAIL]    $Message"
    $script:FailCount++
}

function Test-Command($Name) {
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Test-ListeningPort([int]$Port) {
    $hits = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    return $hits
}

Write-Host "SIOSE infrastructure validation (Faisal)"
Write-Host "Inspect only. No installs. No container changes."
Write-Host "------------------------------------------------"

# --- OS ---
try {
    $os = Get-CimInstance Win32_OperatingSystem
    Write-Pass ("OS: {0} {1} (build {2})" -f $os.Caption, $os.OSArchitecture, $os.Version)
} catch {
    Write-Fail "Could not read operating system information"
}

try {
    $hostname = $env:COMPUTERNAME
    Write-Pass "Hostname: $hostname"
} catch {
    Write-Fail "Could not read hostname"
}

# --- CPU ---
try {
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    $arch = $env:PROCESSOR_ARCHITECTURE
    Write-Pass ("Architecture: {0}" -f $arch)
    Write-Pass ("CPU: {0} ({1} cores / {2} logical processors)" -f $cpu.Name.Trim(), $cpu.NumberOfCores, $cpu.NumberOfLogicalProcessors)
    if ($cpu.NumberOfCores -lt 2) {
        Write-Warn "Fewer than 2 CPU cores. Docker Desktop may be slow."
    }
} catch {
    Write-Fail "Could not read CPU information"
}

# --- RAM ---
try {
    $cs = Get-CimInstance Win32_ComputerSystem
    $totalGb = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
    Write-Pass ("RAM: {0} GB total" -f $totalGb)
    if ($totalGb -lt 4) {
        Write-Fail "Less than 4 GB RAM. Docker Desktop + n8n needs more memory."
    } elseif ($totalGb -lt 8) {
        Write-Warn "Less than 8 GB RAM. Close extra apps before running Docker Desktop."
    }
} catch {
    Write-Fail "Could not read RAM information"
}

# --- Disk ---
try {
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $freeGb = [math]::Round($disk.FreeSpace / 1GB, 2)
    $sizeGb = [math]::Round($disk.Size / 1GB, 2)
    Write-Pass ("Disk C: {0} GB free of {1} GB" -f $freeGb, $sizeGb)
    if ($freeGb -lt 5) {
        Write-Fail "Less than 5 GB free on C:. Docker images need disk space."
    } elseif ($freeGb -lt 10) {
        Write-Warn "Less than 10 GB free on C:. Images and volumes may fill the disk."
    }
} catch {
    Write-Fail "Could not read disk information"
}

# --- Terraform ---
if (Test-Command "terraform") {
    $tfVer = (terraform version -json 2>$null | ConvertFrom-Json).terraform_version
    if (-not $tfVer) {
        $tfVer = (terraform version | Select-Object -First 1)
    }
    Write-Pass "Terraform: $tfVer"
} else {
    Write-Fail "Terraform is not installed or not on PATH"
}

# --- Git ---
if (Test-Command "git") {
    $gitVer = (git --version)
    Write-Pass "Git: $gitVer"
} else {
    Write-Fail "Git is not installed or not on PATH"
}

# --- Docker CLI ---
$dockerCli = $false
if (Test-Command "docker") {
    $dockerCli = $true
    $dockerVer = (docker version --format '{{.Client.Version}}' 2>$null)
    if (-not $dockerVer) { $dockerVer = "detected" }
    Write-Pass "Docker CLI: $dockerVer"
} else {
    Write-Fail "Docker CLI is not installed or not on PATH"
}

# --- Docker daemon ---
if ($dockerCli) {
    docker info --format '{{.ServerVersion}}' 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $engine = docker info --format '{{.OperatingSystem}} {{.Architecture}}' 2>$null
        Write-Pass "Docker engine is reachable ($engine)"
    } else {
        Write-Fail "Docker CLI exists but the engine is not running. Start Docker Desktop."
    }
}

# --- Docker Compose ---
if ($dockerCli) {
    $composeOut = docker compose version 2>$null
    if ($LASTEXITCODE -eq 0 -and $composeOut) {
        Write-Pass "Docker Compose: $composeOut"
    } else {
        Write-Fail "Docker Compose plugin is not available (docker compose version failed)"
    }
} else {
    Write-Fail "Docker Compose not checked because Docker CLI is missing"
}

# --- Bash / WSL ---
$gitBash = "C:\Program Files\Git\bin\bash.exe"
if (Test-Path $gitBash) {
    $bashVer = & $gitBash --version 2>$null | Select-Object -First 1
    Write-Pass "Git Bash: $bashVer"
} elseif (Test-Command "bash") {
    $bashVer = bash --version 2>$null | Select-Object -First 1
    Write-Pass "Bash: $bashVer"
} else {
    Write-Warn "Bash was not found. Rahaf's .sh scripts will need Git Bash or WSL."
}

if (Test-Command "wsl") {
    # wsl.exe prints UTF-16; strip null bytes so -match works on Windows PowerShell 5.1.
    $wslList = ((wsl -l -v 2>$null | Out-String) -replace "`0", "")
    if ($wslList -match "Ubuntu") {
        Write-Pass "WSL is available (Ubuntu distro present)"
    } elseif ($wslList -match "VERSION") {
        Write-Warn "WSL is installed but Ubuntu was not listed. Windows Docker Desktop can still be used."
    } else {
        Write-Warn "WSL command ran but distro list was empty. Windows Docker Desktop can still be used."
    }
} else {
    Write-Warn "WSL was not found. Docker Desktop on Windows is still an acceptable local model."
}

# --- DNS ---
try {
    $dns = Resolve-DnsName github.com -ErrorAction Stop | Select-Object -First 1
    Write-Pass ("DNS: github.com -> {0}" -f $dns.IPAddress)
} catch {
    Write-Fail "DNS lookup for github.com failed"
}

# --- HTTPS / internet ---
$httpsOk = $false
try {
    $resp = Invoke-WebRequest -Uri "https://github.com" -Method Head -UseBasicParsing -TimeoutSec 15
    if ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 400) {
        Write-Pass ("HTTPS: github.com returned {0}" -f [int]$resp.StatusCode)
        $httpsOk = $true
    }
} catch {
    Write-Fail ("HTTPS to github.com failed: {0}" -f $_.Exception.Message)
}

try {
    $tfReg = Invoke-WebRequest -Uri "https://registry.terraform.io" -Method Head -UseBasicParsing -TimeoutSec 15
    Write-Pass ("HTTPS: registry.terraform.io returned {0}" -f [int]$tfReg.StatusCode)
} catch {
    if ($httpsOk) {
        Write-Warn "github.com works but registry.terraform.io did not. terraform init may fail."
    } else {
        Write-Fail "HTTPS to registry.terraform.io failed"
    }
}

# --- Ports ---
# 5678 is the preferred n8n host port. Occupied means DevOps should use 5679:5678.
$n8nHits = Test-ListeningPort 5678
if ($n8nHits) {
    $proc = Get-Process -Id $n8nHits[0].OwningProcess -ErrorAction SilentlyContinue
    $pname = if ($proc) { $proc.ProcessName } else { "pid $($n8nHits[0].OwningProcess)" }
    Write-Warn "Port 5678 is in use ($pname). Ask Rahaf to publish 5679:5678. Do not kill the process from this script."
} else {
    Write-Pass "Port 5678 is free on the host (preferred n8n mapping 5678:5678)"
}

# 5432 must remain unpublished by Compose. A host Postgres is a warning, not a reason to expose Docker Postgres.
$pgHits = Test-ListeningPort 5432
if ($pgHits) {
    $proc = Get-Process -Id $pgHits[0].OwningProcess -ErrorAction SilentlyContinue
    $pname = if ($proc) { $proc.ProcessName } else { "pid $($pgHits[0].OwningProcess)" }
    Write-Warn "Port 5432 is in use on the host ($pname). Docker PostgreSQL must stay internal-only (no host ports: mapping)."
} else {
    Write-Pass "Port 5432 is free on the host. Still do not publish PostgreSQL from Compose."
}

Write-Host "------------------------------------------------"
if ($FailCount -eq 0) {
    Write-Host ("Infrastructure status: READY ({0} warning(s))" -f $WarnCount)
    Write-Host "DevOps may start n8n + PostgreSQL with Docker Compose."
    exit 0
}

Write-Host ("Infrastructure status: NOT READY ({0} fail, {1} warning)" -f $FailCount, $WarnCount)
Write-Host "Fix FAIL items before asking Rahaf to deploy."
exit 1
