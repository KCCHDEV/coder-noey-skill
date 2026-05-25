<#
.SYNOPSIS
    NEY Coder AI - Init Project (Windows PowerShell 5.1+)
.DESCRIPTION
    Sets up a new or existing project with NEY agent system.
    Creates: work.md, memory/, archive/, docs/, .opencode/
.PARAMETER Dir
    Target project directory (default: current directory)
.PARAMETER Name
    Project name (default: directory name)
.PARAMETER Agents
    Agents to install: "all" or comma-sep "ney,fha,masa"
.PARAMETER Mini
    Use compact SKILL (mini.md)
.PARAMETER NoGit
    Skip git init
.EXAMPLE
    .\init-project.ps1 -Dir ..\my-project -Name "My App"
    .\init-project.ps1 -Mini -Agents ney,eria
#>

param(
    [string]$Dir = "",
    [string]$Name = "",
    [string]$Agents = "all",
    [switch]$Mini,
    [switch]$NoGit
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InRepo = Test-Path (Join-Path (Join-Path (Join-Path $ScriptDir "agents") "ney") "SKILL.md")
$Variant = if ($Mini) { "mini" } else { "SKILL" }
$RepoUrl = "https://github.com/KCCHDEV/coder-noey-skill"
$RawUrl = "https://raw.githubusercontent.com/KCCHDEV/coder-noey-skill/main"

function Write-Log  { Write-Host "[NEV] $($args[0])" -ForegroundColor Green }
function Write-Warn { Write-Host "[WARN] $($args[0])" -ForegroundColor Yellow }
function Write-Info { Write-Host "[INFO] $($args[0])" -ForegroundColor Cyan }

# ----- Determine target -----
if ([string]::IsNullOrWhiteSpace($Dir)) {
    $TargetDir = (Get-Location).Path
} else {
    $TargetDir = Resolve-Path $Dir -ErrorAction SilentlyContinue
    if (-not $TargetDir) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
        $TargetDir = (Resolve-Path $Dir).Path
    }
}

if ([string]::IsNullOrWhiteSpace($Name)) {
    $ProjectName = Split-Path $TargetDir -Leaf
} else {
    $ProjectName = $Name
}

if ($Agents -eq "all") {
    $agentList = @("yui", "ney", "fha", "masa", "eria", "mochi")
} else {
    $agentList = $Agents.Split(',') | ForEach-Object { $_.Trim() }
}

Write-Host ""
Write-Host "NEY Coder AI - Init Project" -ForegroundColor Cyan
Write-Host "  Project: $ProjectName"
Write-Host "  Target:  $TargetDir"
Write-Host ""

if (Test-Path (Join-Path $TargetDir "work.md")) {
    Write-Warn "work.md already exists - project may already be initialized."
    $answer = Read-Host "Continue anyway? [y/N]"
    if ($answer -notmatch '^[Yy]') { Write-Log "Aborted."; exit 0 }
}

# ----- Create structure -----
Write-Log "Creating project structure..."
New-Item -ItemType Directory -Path (Join-Path $TargetDir "memory") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $TargetDir "archive") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path (Join-Path $TargetDir "docs") "plans") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path (Join-Path $TargetDir "docs") "designs") -Force | Out-Null

# ----- work.md -----
$workContent = @"
# work.md - $ProjectName

> Auto-created by NEY Coder AI Init Project

## Current Status

- State: active
- Last updated: $(Get-Date -Format 'yyyy-MM-dd')
- Current task:
- Main goal:

## User Request

...

## Active Plan

- [ ] ...

## Decisions

| Date | Decision | Reason |
|---|---|---|

## Files Changed

| File | Action | Notes |
|---|---|---|

## Next Steps

- [ ] ...

## Resume Prompt

Read work.md then continue from:
1. ...
"@
Set-Content -Path (Join-Path $TargetDir "work.md") -Value $workContent -Encoding UTF8
Write-Log "  Created: work.md"

# ----- startup.md -----
$startupContent = @"
# Startup - Project Entry Point

> AI Agent: Read this file before starting work.

## Read Order
1. startup.md (this file)
2. work.md
3. memory/mem.md
4. AGENTS.md
5. .opencode/skills/<your-agent>/SKILL.md

## Team
- Yui: Orchestrator - routes tasks
- Ney: DEV - implement
- Fha: Planner - spec
- Masa: Logic - design
- Eria: UI - design
- Mochi: PM - manage

## Rules
- No Chinese - Thai + English only
- Update work.md after every action
- Archive before deleting code
"@
Set-Content -Path (Join-Path $TargetDir "startup.md") -Value $startupContent -Encoding UTF8
Write-Log "  Created: startup.md"

# ----- memory/mem.md -----
$memContent = @"
# mem.md - Long-Term Memory

> Store decisions, constraints, preferences across sessions

## Decisions

| Date | Decision | Context | Reason |
|---|---|---|---|

## Constraints

- ...

## Preferences

- ...
"@
Set-Content -Path (Join-Path (Join-Path $TargetDir "memory") "mem.md") -Value $memContent -Encoding UTF8

$summaryContent = @"
# Summary - Project Overview

## Tech Stack

- ...

## Structure

- work.md
- memory/
- archive/
- docs/

## Team

- Ney (DEV) - implement
- Fha (plan) - spec
- Masa (logic) - design
- Eria (UI) - design
- Yui (orchestrate) - route
- Mochi (PM) - manage
"@
Set-Content -Path (Join-Path (Join-Path $TargetDir "memory") "summary.md") -Value $summaryContent -Encoding UTF8
Write-Log "  Created: memory/mem.md + memory/summary.md"

# ----- archive log -----
$archiveContent = @"
# ARCHIVE_LOG.md

> Log of all archived/replaced files

| Date | File | Reason | Restore |
|---|---|---|---|
"@
Set-Content -Path (Join-Path (Join-Path $TargetDir "archive") "ARCHIVE_LOG.md") -Value $archiveContent -Encoding UTF8
Write-Log "  Created: archive/ARCHIVE_LOG.md"

# ----- .opencode/skills/ -----
Write-Log "Setting up OpenCode skills..."
$skillsDir = Join-Path (Join-Path $TargetDir ".opencode") "skills"

function Download-Skill {
    param([string]$Agent, [string]$Variant, [string]$DestPath)
    New-Item -ItemType Directory -Path (Split-Path $DestPath -Parent) -Force | Out-Null
    if ($InRepo) {
        $src = Join-Path $ScriptDir "agents"
        $src = Join-Path $src $Agent
        $src = Join-Path $src "$Variant.md"
        if (-not (Test-Path $src)) {
            $src = Join-Path $ScriptDir "agents"
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

foreach ($agent in $agentList) {
    $agentDir = Join-Path $skillsDir $agent
    $dst = Join-Path $agentDir "SKILL.md"
    if (Download-Skill -Agent $agent -Variant $Variant -DestPath $dst) {
        Write-Log "  ${Variant}: $agent - .opencode/skills/$agent/"
    } else {
        Write-Warn "  Skipping $agent - source not found"
    }
}

# ----- opencode.json -----
$cfg = Join-Path (Join-Path $TargetDir ".opencode") "opencode.json"
if (-not (Test-Path $cfg)) {
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

# ----- AGENTS.md -----
$agentsFile = Join-Path $TargetDir "AGENTS.md"
if (-not (Test-Path $agentsFile)) {
    $agentsContent = @"
You are Ney, a feminine AI DEV coding teammate.
You implement, refactor, debug, and maintain code.

Core behavior:
- Read the task carefully before editing.
- Inspect relevant files first.
- Never delete important code; archive first.
- Keep UI clean, cute, responsive.
- Validate backend input.
- Avoid secrets, hard deletes, rewrites.
- Use terminal-friendly summaries.

Memory:
- Always maintain work.md for non-trivial tasks.
- Read work.md before continuing work.
- Update work.md after planning, edits, tests.

Team:
- Yui: Orchestrator - routes tasks, Auto/Step mode
- Fha: Planner - specs, architecture
- Masa: Logic - data flow, algorithms
- Eria: UI - design, components
- Mochi: PM - tasks, deadlines, tracking
"@
    Set-Content -Path $agentsFile -Value $agentsContent -Encoding UTF8
    Write-Log "  Created: AGENTS.md"
}

# ----- .gitignore -----
$gi = Join-Path $TargetDir ".gitignore"
if (-not (Test-Path $gi)) {
    $giContent = @"
node_modules/
.next/
dist/
build/
coverage/
.cache/
.DS_Store
*.log
.opencode/
"@
    Set-Content -Path $gi -Value $giContent -Encoding UTF8
    Write-Log "  Created: .gitignore"
}

# ----- Git init -----
if (-not $NoGit) {
    $gitDir = Join-Path $TargetDir ".git"
    if (-not (Test-Path $gitDir)) {
        Write-Log "Initializing git repository..."
        Push-Location $TargetDir
        git init -q
        git add -A
        git commit -q -m "chore: init project with NEY Coder AI system"
        Pop-Location
        Write-Log "  Git initialized + initial commit"
    } else {
        Write-Log "  Git already initialized (skipped)"
    }
} else {
    Write-Log "  Git init skipped"
}

# ----- Done -----
Write-Host ""
Write-Host "Init Complete!" -ForegroundColor Cyan
Write-Host ""
Write-Log "Project: $ProjectName"
Write-Log "Target:  $TargetDir"
Write-Host ""
Write-Info "Structure created:"
Write-Host "  - work.md"
Write-Host "  - AGENTS.md"
Write-Host "  - memory/"
Write-Host "  - archive/"
Write-Host "  - docs/"
Write-Host "  - .opencode/"
Write-Host ""
Write-Info "Next: cd $TargetDir && opencode"
