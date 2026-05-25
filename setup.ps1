<#
.SYNOPSIS
    NEY Coder AI - Auto Setup (Windows PowerShell 5.1+)
    Auto-downloads skills from GitHub if not in repo.
    Supports: full/mini, interactive agent selection.
#>

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/KCCHDEV/coder-noey-skill"
$RawUrl = "https://raw.githubusercontent.com/KCCHDEV/coder-noey-skill/main"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$AgentsDir = Join-Path $ScriptDir "agents"
$InRepo = Test-Path (Join-Path (Join-Path $AgentsDir "ney") "SKILL.md")

$AgentList = @(
    @{ Num=1; Name="ney";   Desc="Ney   - DEV Implementer" }
    @{ Num=2; Name="fha";   Desc="Fha   - Project Planner" }
    @{ Num=3; Name="masa";  Desc="Masa  - Logic Designer" }
    @{ Num=4; Name="eria";  Desc="Eria  - UI/UX Designer" }
    @{ Num=5; Name="yui";   Desc="Yui   - Orchestrator" }
    @{ Num=6; Name="mochi"; Desc="Mochi - Project Manager" }
)

function Write-Log  { Write-Host "[NEV] $($args[0])" -ForegroundColor Green }
function Write-Warn { Write-Host "[WARN] $($args[0])" -ForegroundColor Yellow }
function Write-Info { Write-Host "[INFO] $($args[0])" -ForegroundColor Cyan }

# ----- Header -----
Write-Host ""
Write-Host "NEY Coder AI - Auto Setup (Windows)" -ForegroundColor Cyan
Write-Host ""

# ----- Auto-download if not in repo -----
$WorkDir = $ScriptDir
if (-not $InRepo) {
    Write-Log "Not in NEY repo - will download from GitHub"
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
            $WorkDir = $tmpDir
            $InRepo = $true
            Write-Log "Cloned to $tmpDir"
        } catch {
            Write-Warn "git clone failed - falling back to individual downloads"
        }
    } else {
        $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) "ney-dl"
        New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
        $WorkDir = $tmpDir
    }
} else {
    Write-Log "Running from NEY repo: $ScriptDir"
}

function Download-Skill {
    param([string]$Agent, [string]$Variant, [string]$DestPath)
    New-Item -ItemType Directory -Path (Split-Path $DestPath -Parent) -Force | Out-Null
    if ($InRepo) {
        $src = Join-Path $WorkDir "agents"
        $src = Join-Path $src $Agent
        $src = Join-Path $src "$Variant.md"
        if (-not (Test-Path $src)) {
            $src = Join-Path $WorkDir "agents"
            $src = Join-Path $src $Agent
            $src = Join-Path $src "SKILL.md"
        }
        if (Test-Path $src) { Copy-Item -LiteralPath $src -Destination $DestPath -Force; return $true }
        return $false
    }
    $url = "$RawUrl/agents/$Agent/$Variant.md"
    try {
        Invoke-WebRequest -Uri $url -OutFile $DestPath -UseBasicParsing -ErrorAction Stop | Out-Null
        return $true
    } catch { return $false }
}

# ----- Select agents -----
Write-Host ""
Write-Info "Available agents:"
foreach ($a in $AgentList) { Write-Host "  $($a.Num)) $($a.Desc)" }
Write-Host "  7) ALL agents"
$selection = Read-Host "`nSelect agents (comma-separated, e.g. 1,3,5 or 7 for all)"

$selected = @()
if ($selection -eq "7") {
    $selected = $AgentList
} else {
    $selection -split ',' | ForEach-Object {
        $n = $_.Trim()
        if ($n -match '^[1-6]$') { $selected += $AgentList | Where-Object { $_.Num -eq [int]$n } }
    }
}

# ----- Select variant -----
Write-Host ""
Write-Info "Skill variant:"
Write-Host "  1) Full - complete SKILL.md (detailed)"
Write-Host "  2) Mini - compact SKILL.md (~30 lines)"
$v = Read-Host "Choose [1/2]"
$variant = if ($v -eq "2") { "mini" } else { "SKILL" }

# ----- Install -----
Write-Host ""
Write-Log "Installing $variant skills for selected agents..."
Write-Host ""

$ocDir = Join-Path $ScriptDir ".opencode"
$skillsDir = Join-Path $ocDir "skills"

foreach ($a in $selected) {
    $agentDir = Join-Path $skillsDir $a.Name
    $dst = Join-Path $agentDir "SKILL.md"
    if (Download-Skill -Agent $a.Name -Variant $variant -DestPath $dst) {
        Write-Log "  OK $($a.Desc)"
    } else {
        Write-Warn "  FAIL $($a.Desc) - download failed"
    }
}

# ----- Config -----
$cfg = Join-Path $ocDir "opencode.json"
if (-not (Test-Path $cfg)) {
    New-Item -ItemType Directory -Path $ocDir -Force | Out-Null
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
Write-Host "Setup Complete!" -ForegroundColor Cyan
Write-Host ""
Write-Log "Installed: $variant skills"
foreach ($a in $selected) { Write-Host "  - $($a.Desc)" }
Write-Host ""
Write-Info "Start OpenCode:  opencode"
