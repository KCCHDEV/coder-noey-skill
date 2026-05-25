<#
.SYNOPSIS
    NEY Coder AI — Windows Auto Setup (PowerShell)
.DESCRIPTION
    Installs agent skills for OpenCode, creates config, cross-platform compatible.
#>

$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$OpenCodeDir = Join-Path $RepoDir ".opencode"
$SkillsDir   = Join-Path $OpenCodeDir "skills"

$Agents = @(
    @{ Name = "yui";   Desc = "Yui Orchestrator" }
    @{ Name = "ney";   Desc = "Ney DEV Implementer" }
    @{ Name = "fha";   Desc = "Fha Project Planner" }
    @{ Name = "masa";  Desc = "Masa Logic Designer" }
    @{ Name = "eria";  Desc = "Eria UI/UX Designer" }
    @{ Name = "mochi"; Desc = "Mochi Project Manager" }
)

function Write-Log    { Write-Host "[NEV] $($args[0])" -ForegroundColor Green }
function Write-Warn   { Write-Host "[WARN] $($args[0])" -ForegroundColor Yellow }
function Write-Err    { Write-Host "[ERR] $($args[0])" -ForegroundColor Red }
function Write-Info   { Write-Host "[INFO] $($args[0])" -ForegroundColor Cyan }

function Install-Skills {
    Write-Log "Creating OpenCode skills directory..."
    New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null

    foreach ($agent in $Agents) {
        $src = Join-Path $RepoDir "agents" $agent.Name "SKILL.md"
        $dst = Join-Path $SkillsDir $agent.Name "SKILL.md"

        if (-not (Test-Path $src)) {
            Write-Warn "Source not found: $src"
            continue
        }

        New-Item -ItemType Directory -Path (Join-Path $SkillsDir $agent.Name) -Force | Out-Null
        Copy-Item -LiteralPath $src -Destination $dst -Force
        Write-Log "  Installed: $($agent.Name) → $dst"
    }

    # Copy shared memory reference
    $sharedSrc = Join-Path $RepoDir "shared" "memory"
    $sharedDst = Join-Path $SkillsDir "shared" "memory"
    if (Test-Path $sharedSrc) {
        New-Item -ItemType Directory -Path $sharedDst -Force | Out-Null
        Copy-Item -LiteralPath "$sharedSrc\*" -Destination $sharedDst -Recurse -Force
    }

    Write-Log "Skills installed to $SkillsDir"
}

function New-Config {
    $cfg = Join-Path $OpenCodeDir "opencode.json"
    if (Test-Path $cfg) {
        Write-Warn "Config already exists: $cfg"
        return
    }

    Write-Log "Creating OpenCode config..."
    $json = @'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "opencode-go/deepseek-v4-flash",
  "small_model": "opencode-go/deepseek-v4-flash",
  "permission": {
    "*": "allow"
  }
}
'@
    Set-Content -Path $cfg -Value $json -Encoding UTF8
    Write-Log "Config created: $cfg"
}

function Update-GitIgnore {
    $gi = Join-Path $RepoDir ".gitignore"
    if (Test-Path $gi) {
        $content = Get-Content -LiteralPath $gi -Raw
        if ($content -match '\.opencode/') { return }
    }
    Write-Log "Adding .opencode/ to .gitignore..."
    Add-Content -Path $gi -Value "`n.opencode/" -Encoding UTF8
}

function Show-Summary {
    Write-Host ""
    Write-Host "╭─────────────────────────────────────────────╮" -ForegroundColor Cyan
    Write-Host "│   Setup Complete!                           │" -ForegroundColor Cyan
    Write-Host "╰─────────────────────────────────────────────╯" -ForegroundColor Cyan
    Write-Host ""

    Write-Log "Agents installed:"
    foreach ($agent in $Agents) {
        Write-Host "  • $($agent.Name) — $($agent.Desc)"
    }

    Write-Host ""
    Write-Info "To start OpenCode: opencode"
    Write-Info "To configure model: .\opencode.ps1"
    Write-Info "To run setup again: .\setup.ps1"
    Write-Host ""
}

# ----- Main -----
Write-Host ""
Write-Host "╭─────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "│   NEY Coder AI — Auto Setup (Windows)       │" -ForegroundColor Cyan
Write-Host "╰─────────────────────────────────────────────╯" -ForegroundColor Cyan
Write-Host ""

Install-Skills
New-Config
Update-GitIgnore
Show-Summary
