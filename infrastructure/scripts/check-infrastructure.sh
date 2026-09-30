#!/usr/bin/env bash
# check-infrastructure.sh
# Faisal / Infrastructure — host prerequisite validation only.
#
# Optional Linux/WSL companion to check-infrastructure.ps1.
# Does not install software, start Compose, or change firewall rules.
#
# Usage:
#   chmod +x infrastructure/scripts/check-infrastructure.sh
#   ./infrastructure/scripts/check-infrastructure.sh

set -u

FAIL=0
WARN=0

pass() { printf '[PASS]    %s\n' "$1"; }
warn() { printf '[WARNING] %s\n' "$1"; WARN=$((WARN + 1)); }
fail() { printf '[FAIL]    %s\n' "$1"; FAIL=$((FAIL + 1)); }

echo "SIOSE infrastructure validation (Faisal)"
echo "Inspect only. No installs. No container changes."
echo "------------------------------------------------"

if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  pass "OS: ${PRETTY_NAME:-unknown}"
else
  pass "OS: $(uname -s)"
fi

pass "Hostname: $(hostname)"
pass "Architecture: $(uname -m)"

if command -v nproc >/dev/null 2>&1; then
  CORES="$(nproc)"
  pass "CPU logical processors: ${CORES}"
  if [[ "${CORES}" -lt 2 ]]; then
    warn "Fewer than 2 CPU cores. Docker may be slow."
  fi
else
  warn "Could not read CPU count"
fi

if [[ -r /proc/meminfo ]]; then
  MEM_KB="$(awk '/MemTotal/ {print $2}' /proc/meminfo)"
  MEM_GB="$(awk -v kb="${MEM_KB}" 'BEGIN { printf "%.2f", kb/1024/1024 }')"
  pass "RAM: ${MEM_GB} GB total"
else
  warn "Could not read RAM"
fi

if command -v df >/dev/null 2>&1; then
  FREE_G="$(df -BG --output=avail / | tail -1 | tr -dc '0-9')"
  pass "Disk / : ${FREE_G} GB free"
  if [[ -n "${FREE_G}" && "${FREE_G}" -lt 5 ]]; then
    fail "Less than 5 GB free disk"
  elif [[ -n "${FREE_G}" && "${FREE_G}" -lt 10 ]]; then
    warn "Less than 10 GB free disk"
  fi
fi

if command -v terraform >/dev/null 2>&1; then
  pass "Terraform: $(terraform version | head -n 1)"
else
  fail "Terraform is not installed or not on PATH"
fi

if command -v git >/dev/null 2>&1; then
  pass "Git: $(git --version)"
else
  fail "Git is not installed or not on PATH"
fi

if command -v docker >/dev/null 2>&1; then
  pass "Docker CLI: $(docker version --format '{{.Client.Version}}' 2>/dev/null || echo detected)"
  if docker info >/dev/null 2>&1; then
    pass "Docker engine is reachable"
  else
    fail "Docker CLI exists but the engine is not running"
  fi
  if docker compose version >/dev/null 2>&1; then
    pass "Docker Compose: $(docker compose version)"
  else
    fail "Docker Compose plugin is not available"
  fi
else
  fail "Docker CLI is not installed or not on PATH"
  fail "Docker Compose not checked because Docker CLI is missing"
fi

if command -v bash >/dev/null 2>&1; then
  pass "Bash: $(bash --version | head -n 1)"
else
  fail "Bash is not available"
fi

if getent hosts github.com >/dev/null 2>&1 || nslookup github.com >/dev/null 2>&1; then
  pass "DNS: github.com resolved"
else
  fail "DNS lookup for github.com failed"
fi

if command -v curl >/dev/null 2>&1; then
  if curl -fsS -I --max-time 15 https://github.com >/dev/null 2>&1; then
    pass "HTTPS: github.com reachable"
  else
    fail "HTTPS to github.com failed"
  fi
  if curl -fsS -I --max-time 15 https://registry.terraform.io >/dev/null 2>&1; then
    pass "HTTPS: registry.terraform.io reachable"
  else
    warn "registry.terraform.io was not reachable; terraform init may fail"
  fi
else
  warn "curl is not installed; skipped HTTPS checks"
fi

port_in_use() {
  local port="$1"
  local os
  os="$(uname -s)"
  if command -v ss >/dev/null 2>&1; then
    ss -lnt | grep -Eq ":${port}([[:space:]]|$)"
  elif [[ "${os}" == MINGW* || "${os}" == MSYS* || "${os}" == CYGWIN* ]]; then
    # Git Bash uses Windows netstat, which does not support -lnt.
    netstat -ano 2>/dev/null | grep LISTENING | grep -Eq ":${port}[[:space:]]"
  else
    netstat -lnt 2>/dev/null | grep -Eq ":${port}[[:space:]]"
  fi
}

if port_in_use 5678; then
  warn "Port 5678 is in use. Ask Rahaf to publish 5679:5678. This script will not kill the process."
else
  pass "Port 5678 is free on the host (preferred n8n mapping 5678:5678)"
fi

if port_in_use 5432; then
  warn "Port 5432 is in use on the host. Docker PostgreSQL must stay internal-only."
else
  pass "Port 5432 is free on the host. Still do not publish PostgreSQL from Compose."
fi

echo "------------------------------------------------"
if [[ "${FAIL}" -eq 0 ]]; then
  echo "Infrastructure status: READY (${WARN} warning(s))"
  exit 0
fi

echo "Infrastructure status: NOT READY (${FAIL} fail, ${WARN} warning)"
exit 1
