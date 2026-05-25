<#
.SYNOPSIS
    NEY Coder AI - Startup Message + Health Check
.DESCRIPTION
    Shows welcome banner, checks if skills are installed,
    and offers to run setup if needed.
#>

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$Agents = @("yui", "ney", "fha", "masa", "eria", "mochi")
$skillsDir = Join-Path (Join-Path $ScriptDir ".opencode") "skills"

function Write-Log  { Write-Host "[NEV] $($args[0])" -ForegroundColor Green }
function Write-Warn { Write-Host "[WARN] $($args[0])" -ForegroundColor Yellow }
function Write-Info { Write-Host "[INFO] $($args[0])" -ForegroundColor Cyan }

# ----- Banner -----
Write-Host ""
Write-Host "  ╭──────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "  │                                              │" -ForegroundColor Cyan
Write-Host "  │      NEY Coder AI — Multi-Agent System       │" -ForegroundColor Cyan
Write-Host "  │                                              │" -ForegroundColor Cyan
Write-Host "  │    Agents:                                   │" -ForegroundColor Cyan
Write-Host "  │      Yui  (Orchestrator)    Auto/Step mode   │" -ForegroundColor Cyan
Write-Host "  │      Ney  (DEV Implementer)                  │" -ForegroundColor Cyan
Write-Host "  │      Fha  (Project Planner)                  │" -ForegroundColor Cyan
Write-Host "  │      Masa (Logic Designer)                   │" -ForegroundColor Cyan
Write-Host "  │      Eria (UI/UX Designer)                   │" -ForegroundColor Cyan
Write-Host "  │      Mochi (Project Manager)                 │" -ForegroundColor Cyan
Write-Host "  │                                              │" -ForegroundColor Cyan
Write-Host "  │    Memory: shared/memory/                    │" -ForegroundColor Cyan
Write-Host "  │                                              │" -ForegroundColor Cyan
Write-Host "  ╰──────────────────────────────────────────────╯" -ForegroundColor Cyan
Write-Host ""

# ----- Health check -----
$allInstalled = $true
Write-Info "Health check..."
foreach ($agent in $Agents) {
    $skillFile = Join-Path (Join-Path $skillsDir $agent) "SKILL.md"
    if (Test-Path $skillFile) {
        Write-Log "  OK $agent"
    } else {
        Write-Warn "  MISSING $agent"
        $allInstalled = $false
    }
}

if (-not $allInstalled) {
    Write-Warn "Some agents are not installed."
    $answer = Read-Host "Run .\setup.ps1 now? [Y/n]"
    if ($answer -ne 'n' -and $answer -ne 'N') {
        & (Join-Path $ScriptDir "setup.ps1")
    }
} else {
    Write-Log "All agents ready!"
}

# ----- Startup info -----
Write-Host ""
Write-Info "Quick start:"
Write-Host "  .\setup.ps1         - Install/update agent skills"
Write-Host "  .\init-project.ps1  - Init new project"
Write-Host "  .\opencode.ps1      - Configure OpenCode model"
Write-Host "  startup.md          - AI agent startup guide"
Write-Host ""
Write-Info "Read startup.md for AI agent instructions."
Write-Host ""

# ----- Check startup.md -----
$startupMd = Join-Path $ScriptDir "startup.md"
if (Test-Path $startupMd) {
    Write-Log "startup.md found - AI agents will read this on start"
}
