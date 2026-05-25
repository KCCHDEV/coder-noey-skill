# Deploy — NEY Coder AI

> Deployment scripts and configs for installing NEY agents
> to any environment: local dev, server, CI/CD, or Docker.

---

## Usage

### Quick Install (任何环境)

```bash
# Linux / macOS / Git Bash
curl -sL https://raw.githubusercontent.com/KCCHDEV/coder-noey-skill/main/deploy/install.sh | bash

# Windows PowerShell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/KCCHDEV/coder-noey-skill/main/deploy/install.ps1'))
```

### Deploy to OpenCode skills

```bash
./deploy/install.sh --target opencode
```

### Deploy to project

```bash
./deploy/install.sh --target project --dir ../my-project
```

---

## Targets

| Target | Location | Description |
|---|---|---|
| `opencode` | `.opencode/skills/` | Local OpenCode skills |
| `project` | `<dir>/.opencode/skills/` | Specific project |
| `global` | `~/.config/opencode/skills/` | Global user install |
| `server` | `/opt/opencode/skills/` | Server/team install |

---

## Files

| File | Role |
|---|---|
| `install.sh` | Linux / macOS installer |
| `install.ps1` | Windows PowerShell installer |
| `skills/` | Pre-packaged skill files for offline install |
