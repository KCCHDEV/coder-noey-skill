#!/usr/bin/env bash
# ============================================================
# NEY Coder AI — Deploy Installer
# Installs agent skills to: opencode | project | global | server
# Supports: Linux, macOS, Windows (Git Bash / WSL)
# ============================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log()  { echo -e "${GREEN}[NEV]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERR]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }

REPO_URL="https://github.com/KCCHDEV/coder-noey-skill"
RAW_URL="https://raw.githubusercontent.com/KCCHDEV/coder-noey-skill/main"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NEV_ROOT="$(dirname "$SCRIPT_DIR")"

# Detect NEY repo
IN_REPO=false
[ -f "$NEV_ROOT/agents/ney/SKILL.md" ] && IN_REPO=true

TARGET="opencode"
PROJECT_DIR=""
VARIANT="SKILL"
AGENTS="all"

usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --target <t>      Install target: opencode, project, global, server"
    echo "  --dir <path>      Project directory (for --target project)"
    echo "  --mini            Use mini SKILL instead of full"
    echo "  --agents <list>   Comma-separated: ney,fha,masa,eria,yui,mochi"
    echo "  --help            Show help"
    echo ""
    echo "Examples:"
    echo "  $0                                    # local opencode skills"
    echo "  $0 --target project --dir ../my-app   # deploy to project"
    echo "  $0 --target global --mini             # global install, mini skills"
    echo "  $0 --agents ney,eria                  # only 2 agents"
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --target) TARGET="$2"; shift 2 ;;
        --dir) PROJECT_DIR="$2"; shift 2 ;;
        --mini) VARIANT="mini"; shift ;;
        --agents) AGENTS="$2"; shift 2 ;;
        --help|-h) usage ;;
        *) err "Unknown: $1"; usage ;;
    esac
done

# Determine install directory
case "$TARGET" in
    opencode)
        INSTALL_DIR="$(pwd)/.opencode/skills"
        mkdir -p "$INSTALL_DIR"
        ;;
    project)
        [ -z "$PROJECT_DIR" ] && { err "--dir required for --target project"; exit 1; }
        INSTALL_DIR="$PROJECT_DIR/.opencode/skills"
        mkdir -p "$INSTALL_DIR"
        ;;
    global)
        INSTALL_DIR="$HOME/.config/opencode/skills"
        mkdir -p "$INSTALL_DIR"
        ;;
    server)
        INSTALL_DIR="/opt/opencode/skills"
        sudo mkdir -p "$INSTALL_DIR" 2>/dev/null || { mkdir -p "$INSTALL_DIR"; }
        ;;
    *)
        err "Unknown target: $TARGET"; exit 1 ;;
esac

# Determine agents
if [ "$AGENTS" = "all" ]; then
    AGENT_LIST=("yui" "ney" "fha" "masa" "eria" "mochi")
else
    IFS=',' read -ra AGENT_LIST <<< "$AGENTS"
fi

log "Deploying to: $INSTALL_DIR"
log "Variant: $VARIANT"
log "Agents: ${AGENT_LIST[*]}"
echo ""

# Download function
download_skill() {
    local agent="$1" variant="$2" out="$3"
    mkdir -p "$(dirname "$out")"

    if [ "$IN_REPO" = true ]; then
        local src="$NEV_ROOT/agents/$agent/$variant.md"
        [ ! -f "$src" ] && src="$NEV_ROOT/agents/$agent/SKILL.md"
        [ -f "$src" ] && { cp "$src" "$out"; return 0; }
        return 1
    fi

    local url="$RAW_URL/agents/$agent/$variant.md"
    if command -v curl &>/dev/null; then
        curl -sL "$url" -o "$out" && return 0
    elif command -v wget &>/dev/null; then
        wget -q "$url" -O "$out" && return 0
    fi
    return 1
}

# Install each agent
for agent in "${AGENT_LIST[@]}"; do
    agent="$(echo "$agent" | xargs)"
    dst="$INSTALL_DIR/$agent/SKILL.md"

    echo -n "  $agent ... "
    if download_skill "$agent" "$VARIANT" "$dst"; then
        echo -e "${GREEN}OK${NC}"
    else
        echo -e "${RED}FAIL${NC}"
    fi
done

# Install shared memory
mkdir -p "$INSTALL_DIR/shared/memory"
if [ "$IN_REPO" = true ]; then
    cp -r "$NEV_ROOT/shared/memory/"* "$INSTALL_DIR/shared/memory/" 2>/dev/null || true
fi

log "Deploy complete to: $INSTALL_DIR"
