<#
.SYNOPSIS
    NEY Coder AI - Deploy Installer (Windows PowerShell)
.DESCRIPTION
    Installs agent skills to: opencode | project | global
.PARAMETER Target
    Install target: opencode, project, global
.PARAMETER Dir
    Project directory (for -Target project)
.PARAMETER Mini
    Use mini SKILL instead of full
.PARAMETER Agents
    Comma-separated: ney,fha,masa,eria,yui,mochi
.EXAMPLE
    .\deploy\install.ps1
    .\deploy\install.ps1 -Target project -Dir ..\my-app -Mini
    .\deploy\install.ps1 -Target global -Agents ney,eria
#>

param(
    [string]$Target = "opencode",
    [string]$Dir = "",
    [switch]$Mini,
    [string]$Agents = "all"
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$NevRoot = Split-Path $ScriptDir -Parent
$InRepo = Test-Path (Join-Path (Join-Path $NevRoot "agents") "ney" "SKILL.md")
$RawUrl = "https://raw.githubusercontent.com/KCCHDEV/coder-noey-skill/main"
$Variant = if ($Mini) { "mini" } else { "SKILL" }

function Write-Log  { Write-Host "[NEV] $($args[0])" -ForegroundColor Green }
function Write-Warn { Write-Host "[WARN] $($args[0])" -ForegroundColor Yellow }

switch ($Target) {
    "opencode"  { $InstallDir = Join-Path (Get-Location) ".opencode" "skills" }
    "project"   {
        if ([string]::IsNullOrWhiteSpace($Dir)) { throw "-Dir required for -Target project" }
        $InstallDir = Join-Path (Resolve-Path $Dir) ".opencode" "skills"
    }
    "global"    { $InstallDir = Join-Path $Env:USERPROFILE ".config" "opencode" "skills" }
    default     { throw "Unknown target: $Target" }
}

if ($Agents -eq "all") {
    $AgentList = @("yui", "ney", "fha", "masa", "eria", "mochi")
} else {
    $AgentList = $Agents.Split(',') | ForEach-Object { $_.Trim() }
}

New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
Write-Log "Deploying to: $InstallDir"
Write-Log "Variant: $Variant"

function Download-Skill {
    param([string]$Agent, [string]$Variant, [string]$DestPath)
    New-Item -ItemType Directory -Path (Split-Path $DestPath -Parent) -Force | Out-Null
    if ($InRepo) {
        $src = Join-Path $NevRoot "agents" $Agent
        $src = Join-Path $src "$Variant.md"
        if (-not (Test-Path $src)) { $src = Join-Path $NevRoot "agents" $Agent "SKILL.md" }
        if (Test-Path $src) { Copy-Item -LiteralPath $src -Destination $DestPath -Force; return $true }
        return $false
    }
    $url = "$RawUrl/agents/$Agent/$Variant.md"
    try { Invoke-WebRequest -Uri $url -OutFile $DestPath -UseBasicParsing | Out-Null; return $true }
    catch { return $false }
}

foreach ($agent in $AgentList) {
    $dst = Join-Path (Join-Path $InstallDir $agent) "SKILL.md"
    if (Download-Skill -Agent $agent -Variant $Variant -DestPath $dst) {
        Write-Log "  OK $agent"
    } else { Write-Warn "  FAIL $agent" }
}

# Shared memory
$sharedDst = Join-Path $InstallDir "shared" "memory"
New-Item -ItemType Directory -Path $sharedDst -Force | Out-Null
if ($InRepo) {
    Copy-Item -Path (Join-Path (Join-Path $NevRoot "shared") "memory\*") -Destination $sharedDst -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Log "Deploy complete!"
