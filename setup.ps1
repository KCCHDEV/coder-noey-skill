<#
.SYNOPSIS
    NEY Coder AI — Auto Setup (PowerShell)
    Auto-downloads skills from GitHub if not in repo.
    Supports: full/mini, interactive agent selection.
#>

$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/KCCHDEV/coder-noey-skill"
$RawUrl = "https://raw.githubusercontent.com/KCCHDEV/coder-noey-skill/main"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InRepo = Test-Path (Join-Path $ScriptDir "agents" "ney" "SKILL.md")

$Agents = @(
    @{ Num=1; Name="ney";   Desc="Ney   — DEV Implementer" }
    @{ Num=2; Name="fha";   Desc="Fha   — Project Planner" }
    @{ Num=3; Name="masa";  Desc="Masa  — Logic Designer" }
    @{ Num=4; Name="eria";  Desc="Eria  — UI/UX Designer" }
    @{ Num=5; Name="yui";   Desc="Yui   — Orchestrator (entry point)" }
    @{ Num=6; Name="mochi"; Desc="Mochi — Project Manager" }
)

function Write-Log    { Write-Host "[NEV] $($args[0])" -ForegroundColor Green }
function Write-Warn   { Write-Host "[WARN] $($args[0])" -ForegroundColor Yellow }
function Write-Info   { Write-Host "[INFO] $($args[0])" -ForegroundColor Cyan }

# ----- Header -----
Write-Host ""
Write-Host "╭─────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "│   NEY Coder AI — Auto Setup (Windows)       │" -ForegroundColor Cyan
Write-Host "╰─────────────────────────────────────────────╯" -ForegroundColor Cyan
Write-Host ""

# ----- Auto-download -----
$DownloadDir = $ScriptDir
if (-not $InRepo) {
    Write-Log "Not in NEY repo — will download from GitHub"
    Write-Log "  Repo: $RepoUrl"
    Write-Host ""
    Write-Info "Option 1: Download individual skills only"
    Write-Info "Option 2: Clone entire repo (requires git)"
    $cloneChoice = Read-Host "Choose [1/2]"

    if ($cloneChoice -eq "2") {
        $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) "ney-setup"
        if (Test-Path $tmpDir) { Remove-Item -Path $tmpDir -Recurse -Force }
        New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
        try {
            git clone --depth 1 $RepoUrl $tmpDir 2>&1 | Out-Null
            $DownloadDir = $tmpDir
            $InRepo = $true
            Write-Log "Cloned to $tmpDir"
        } catch {
            Write-Warn "git clone failed — falling back to individual downloads"
        }
    } else {
        $DownloadDir = Join-Path ([System.IO.Path]::GetTempPath()) "ney-dl"
        New-Item -ItemType Directory -Path $DownloadDir -Force | Out-Null
    }
} else {
    Write-Log "Running from NEY repo: $ScriptDir"
}

function Download-Skill {
    param($Agent, $Variant, $Destination)
    $url = "$RawUrl/agents/$Agent/$Variant.md"
    New-Item -ItemType Directory -Path (Split-Path $Destination -Parent) -Force | Out-Null

    if ($InRepo) {
        $src = Join-Path $DownloadDir "agents" $Agent "$Variant.md"
        if (Test-Path $src) { Copy-Item -LiteralPath $src -Destination $Destination -Force; return $true }
        $fallback = Join-Path $DownloadDir "agents" $Agent "SKILL.md"
        if (Test-Path $fallback) { Copy-Item -LiteralPath $fallback -Destination $Destination -Force; return $true }
        return $false
    }

    try {
        Invoke-WebRequest -Uri $url -OutFile $Destination -UseBasicParsing -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# ----- Select agents -----
Write-Host ""
Write-Info "Available agents:"
foreach ($a in $Agents) { Write-Host "  $($a.Num)) $($a.Desc)" }
Write-Host "  7) ALL agents"
Write-Host ""
$selection = Read-Host "Select agents (comma-separated, e.g. 1,3,5 or 7 for all)"

$selected = @()
if ($selection -eq "7") {
    $selected = $Agents
} else {
    $selection -split ',' | ForEach-Object {
        $n = $_.Trim()
        if ($n -match '^[1-6]$') {
            $selected += $Agents | Where-Object { $_.Num -eq [int]$n }
        }
    }
}

# ----- Select variant -----
Write-Host ""
Write-Info "Skill variant:"
Write-Host "  1) Full — complete SKILL.md (detailed)"
Write-Host "  2) Mini — compact SKILL.md (~30 lines)"
$v = Read-Host "Choose [1/2]"
$variant = if ($v -eq "2") { "mini" } else { "SKILL" }

# ----- Install -----
Write-Host ""
Write-Log "Installing ${variant} skills for selected agents..."
Write-Host ""

$skillsDir = Join-Path $ScriptDir ".opencode" "skills"

foreach ($a in $selected) {
    $dst = Join-Path $skillsDir $a.Name "SKILL.md"
    if (Download-Skill -Agent $a.Name -Variant $variant -Destination $dst) {
        Write-Log "  ✅ $($a.Desc) → .opencode/skills/$($a.Name)/"
    } else {
        Write-Warn "  ⚠️  $($a.Desc) — download failed, skipping"
    }
}

# ----- Config -----
$cfg = Join-Path $ScriptDir ".opencode" "opencode.json"
if (-not (Test-Path $cfg)) {
    New-Item -ItemType Directory -Path (Split-Path $cfg -Parent) -Force | Out-Null
    $json = @'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "opencode-go/deepseek-v4-flash",
  "small_model": "opencode-go/deepseek-v4-flash",
  "permission": { "*": "allow" }
}
'@
    Set-Content -Path $cfg -Value $json -Encoding UTF8
    Write-Log "  Created: opencode.json"
}

# ----- Summary -----
Write-Host ""
Write-Host "╭─────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "│   Setup Complete!                           │" -ForegroundColor Cyan
Write-Host "╰─────────────────────────────────────────────╯" -ForegroundColor Cyan
Write-Host ""
Write-Log "Installed: $variant skills"
foreach ($a in $selected) { Write-Host "  • $($a.Desc)" }
Write-Host ""
Write-Info "Start OpenCode:  opencode"
Write-Host ""
