#!/usr/bin/env bash
# audit.sh — inventory your Mac's dev environment.
# Safe to run anytime. Read-only, no installs.
#
# Usage:  bash audit.sh

set -u

# ── colors ─────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'
  C_DIM=$'\033[2m'
  C_BOLD=$'\033[1m'
  C_GREEN=$'\033[38;5;46m'    # neon green
  C_RED=$'\033[38;5;196m'     # neon red
  C_CYAN=$'\033[38;5;51m'     # neon cyan
  C_PINK=$'\033[38;5;201m'    # hot pink
  C_YELLOW=$'\033[38;5;226m'  # neon yellow
else
  C_RESET=""; C_DIM=""; C_BOLD=""
  C_GREEN=""; C_RED=""; C_CYAN=""; C_PINK=""; C_YELLOW=""
fi

CHECK="${C_GREEN}✓${C_RESET}"
CROSS="${C_RED}✗${C_RESET}"

MISSING=()

banner() {
  printf "\n${C_PINK}╔══════════════════════════════════════════════════════════╗${C_RESET}\n"
  printf "${C_PINK}║${C_RESET}  ${C_BOLD}${C_CYAN}%-56s${C_RESET}${C_PINK}║${C_RESET}\n" "$1"
  printf "${C_PINK}╚══════════════════════════════════════════════════════════╝${C_RESET}\n"
}

section() {
  printf "\n${C_YELLOW}── %s ──${C_RESET}\n" "$1"
}

# Probe a binary; print version on found, mark missing on not.
# Args: <pretty-name> <command-to-check> [version-args...]
probe() {
  local name="$1"; shift
  local cmd="$1"; shift
  if command -v "$cmd" >/dev/null 2>&1; then
    local ver
    if [[ $# -gt 0 ]]; then
      ver=$("$cmd" "$@" 2>&1 | head -n 1)
    else
      ver=$("$cmd" --version 2>&1 | head -n 1)
    fi
    printf "  %s ${C_BOLD}%-14s${C_RESET} ${C_DIM}%s${C_RESET}\n" "$CHECK" "$name" "$ver"
  else
    printf "  %s ${C_BOLD}%-14s${C_RESET} ${C_DIM}(not installed)${C_RESET}\n" "$CROSS" "$name"
    MISSING+=("$name")
  fi
}

# ── start ──────────────────────────────────────────────────────────────────
banner "DEV ENV AUDIT — $(date '+%Y-%m-%d %H:%M')"

printf "${C_DIM}macOS:${C_RESET}    %s\n" "$(sw_vers -productVersion 2>/dev/null || echo unknown)"
printf "${C_DIM}arch:${C_RESET}     %s\n" "$(uname -m)"
printf "${C_DIM}shell:${C_RESET}    %s\n" "${SHELL:-unknown}"
printf "${C_DIM}user:${C_RESET}     %s\n" "${USER:-unknown}"

section "Foundations"
if xcode-select -p >/dev/null 2>&1; then
  printf "  %s ${C_BOLD}%-14s${C_RESET} ${C_DIM}%s${C_RESET}\n" "$CHECK" "Xcode CLT" "$(xcode-select -p)"
else
  printf "  %s ${C_BOLD}%-14s${C_RESET} ${C_DIM}run: xcode-select --install${C_RESET}\n" "$CROSS" "Xcode CLT"
  MISSING+=("Xcode CLT")
fi
probe "Homebrew" brew --version
# Rosetta only matters on Apple Silicon
if [[ "$(uname -m)" == "arm64" ]]; then
  if /usr/bin/pgrep -q oahd 2>/dev/null; then
    printf "  %s ${C_BOLD}%-14s${C_RESET} ${C_DIM}running${C_RESET}\n" "$CHECK" "Rosetta 2"
  else
    printf "  %s ${C_BOLD}%-14s${C_RESET} ${C_DIM}not running (run: softwareupdate --install-rosetta --agree-to-license)${C_RESET}\n" "$CROSS" "Rosetta 2"
  fi
fi

section "Languages & toolchains"
probe "Node.js"   node --version
probe "npm"       npm --version
probe "pnpm"      pnpm --version
probe "bun"       bun --version
probe "fnm"       fnm --version
probe "Python3"   python3 --version
probe "uv"        uv --version
probe "pyenv"     pyenv --version
probe "Rust"      rustc --version
probe "cargo"     cargo --version
probe "Go"        go version
probe "Swift"     swift --version
probe "Java"      java --version
probe "Deno"      deno --version

section "CLI staples"
probe "git"       git --version
probe "gh"        gh --version
probe "fzf"       fzf --version
probe "ripgrep"   rg --version
probe "fd"        fd --version
probe "bat"       bat --version
probe "eza"       eza --version
probe "jq"        jq --version
probe "yq"        yq --version
probe "zoxide"    zoxide --version
probe "tmux"      tmux -V
probe "neovim"    nvim --version
probe "lazygit"   lazygit --version
probe "btop"      btop --version
probe "tldr"      tldr --version
probe "starship"  starship --version
probe "tree"      tree --version
probe "wget"      wget --version
probe "httpie"    http --version

section "Editors / IDEs"
probe "VS Code"   code --version
probe "Cursor"    cursor --version
probe "Xcode"     xcodebuild -version
probe "JetBrains Toolbox" jetbrains-toolbox --version

section "Containers / cloud"
probe "Docker"    docker --version
probe "OrbStack"  orb --version
probe "kubectl"   kubectl version --client
probe "AWS CLI"   aws --version
probe "gcloud"    gcloud --version

section "Terminal emulators"
for app in "iTerm.app" "Ghostty.app" "Alacritty.app" "kitty.app" "WezTerm.app" "Warp.app"; do
  if [[ -d "/Applications/$app" ]]; then
    printf "  %s ${C_BOLD}%-14s${C_RESET} ${C_DIM}/Applications/%s${C_RESET}\n" "$CHECK" "${app%.app}" "$app"
  else
    printf "  %s ${C_BOLD}%-14s${C_RESET} ${C_DIM}(not installed)${C_RESET}\n" "$CROSS" "${app%.app}"
  fi
done

# ── summary ────────────────────────────────────────────────────────────────
banner "SUMMARY"
if [[ ${#MISSING[@]} -eq 0 ]]; then
  printf "${C_GREEN}🟢 You're already loaded up. Nothing critical missing.${C_RESET}\n"
else
  printf "${C_YELLOW}Missing (%d):${C_RESET}\n" "${#MISSING[@]}"
  for m in "${MISSING[@]}"; do
    printf "  ${C_RED}•${C_RESET} %s\n" "$m"
  done
  printf "\n${C_DIM}Run ${C_RESET}${C_BOLD}bash setup.sh${C_RESET}${C_DIM} to install the staples.${C_RESET}\n"
fi
echo
