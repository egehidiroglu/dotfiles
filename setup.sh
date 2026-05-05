#!/usr/bin/env bash
# setup.sh — install the dev staples and the hacker terminal aesthetic.
# Idempotent: safe to re-run. Skips anything already installed.
#
# Usage:  bash setup.sh
#
# What it does, in order:
#   1. Installs Xcode Command Line Tools if missing.
#   2. Installs Homebrew if missing.
#   3. Installs CLI staples + language toolchains via brew.
#   4. Installs iTerm2 + JetBrains Mono Nerd Font.
#   5. Drops in ~/.zshrc, ~/.config/starship.toml (backs up existing).
#   6. Bootstraps fnm (Node), uv (Python), rustup (Rust).
#
# Anything destructive backs up the original to <file>.bak.YYYYMMDDHHMMSS.

set -uo pipefail

# ── colors ─────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  R=$'\033[0m'; B=$'\033[1m'; D=$'\033[2m'
  G=$'\033[38;5;46m'; RD=$'\033[38;5;196m'
  C=$'\033[38;5;51m'; P=$'\033[38;5;201m'; Y=$'\033[38;5;226m'
else
  R=""; B=""; D=""; G=""; RD=""; C=""; P=""; Y=""
fi

step()  { printf "\n${P}▸${R} ${B}%s${R}\n" "$1"; }
ok()    { printf "  ${G}✓${R} %s\n" "$1"; }
skip()  { printf "  ${D}·${R} ${D}%s${R}\n" "$1"; }
warn()  { printf "  ${Y}!${R} %s\n" "$1"; }
fail()  { printf "  ${RD}✗${R} %s\n" "$1"; }

ts() { date '+%Y%m%d%H%M%S'; }
backup_if_exists() {
  local f="$1"
  if [[ -e "$f" ]]; then
    local bak="${f}.bak.$(ts)"
    cp -p "$f" "$bak"
    warn "backed up existing $(basename "$f") → $(basename "$bak")"
  fi
}

have() { command -v "$1" >/dev/null 2>&1; }

# ── 1. Xcode CLT ───────────────────────────────────────────────────────────
step "Xcode Command Line Tools"
if xcode-select -p >/dev/null 2>&1; then
  ok "already installed at $(xcode-select -p)"
else
  warn "running xcode-select --install (will pop a GUI dialog)"
  xcode-select --install || true
  warn "finish the install dialog, then re-run setup.sh"
  exit 1
fi

# ── 2. Homebrew ────────────────────────────────────────────────────────────
step "Homebrew"
if have brew; then
  ok "already installed: $(brew --version | head -n1)"
else
  warn "installing Homebrew (you'll be asked for your password)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Make sure brew is on PATH for this script's lifetime (Apple Silicon path).
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

brew_install() {
  local pkg="$1"
  if brew list --formula "$pkg" >/dev/null 2>&1; then
    skip "$pkg (already installed)"
  else
    if brew install "$pkg" >/dev/null 2>&1; then
      ok "installed $pkg"
    else
      fail "failed to install $pkg"
    fi
  fi
}

brew_cask_install() {
  local cask="$1"
  if brew list --cask "$cask" >/dev/null 2>&1; then
    skip "$cask (already installed)"
  else
    if brew install --cask "$cask" >/dev/null 2>&1; then
      ok "installed $cask"
    else
      fail "failed to install $cask"
    fi
  fi
}

# ── 3. CLI staples ─────────────────────────────────────────────────────────
step "CLI staples"
for pkg in \
  git gh git-delta \
  fzf ripgrep fd bat eza jq yq zoxide \
  tmux neovim lazygit btop tldr tree wget httpie fastfetch \
  starship \
  fnm uv rustup-init go \
  zsh-autosuggestions zsh-syntax-highlighting \
  cmatrix pipes-sh cbonsai asciiquarium; do
  brew_install "$pkg"
done

# fzf keybindings (idempotent installer)
if have fzf && [[ ! -f "$HOME/.fzf.zsh" ]]; then
  yes | "$(brew --prefix)/opt/fzf/install" --no-bash --no-fish --key-bindings --completion --no-update-rc >/dev/null 2>&1 || true
  ok "wrote ~/.fzf.zsh"
fi

# ── 4. Casks: terminals, apps, fonts ───────────────────────────────────────
step "Casks (apps + fonts)"
brew_cask_install iterm2
brew_cask_install ghostty
brew_cask_install raycast
brew_cask_install nikitabobko/tap/aerospace
brew_cask_install karabiner-elements
brew_cask_install font-jetbrains-mono-nerd-font
brew_cask_install font-fira-code-nerd-font
brew_cask_install font-monaspace

# ── 5. Language toolchains (interactive bits skipped where safe) ───────────
step "Language toolchains"
# Rust
if have rustup; then
  skip "rustup (already configured)"
elif have rustup-init; then
  rustup-init -y --default-toolchain stable --no-modify-path >/dev/null 2>&1 \
    && ok "rustup default-stable installed" \
    || fail "rustup-init failed"
fi
# Node via fnm — install latest LTS if no node yet
if have fnm; then
  if ! have node; then
    fnm install --lts >/dev/null 2>&1 && ok "node LTS installed via fnm" || fail "fnm install failed"
  else
    skip "node already present"
  fi
fi
# Python: brew already gave you python3; uv is the runner
if have uv; then ok "uv ready ($(uv --version))"; fi

# ── 6. Drop in dotfiles ────────────────────────────────────────────────────
step "Dotfiles"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$HOME/.config"

if [[ -f "$SCRIPT_DIR/zshrc" ]]; then
  backup_if_exists "$HOME/.zshrc"
  cp "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"
  ok "wrote ~/.zshrc"
else
  fail "missing 'zshrc' next to setup.sh"
fi

if [[ -f "$SCRIPT_DIR/starship.toml" ]]; then
  backup_if_exists "$HOME/.config/starship.toml"
  cp "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"
  ok "wrote ~/.config/starship.toml"
else
  fail "missing 'starship.toml' next to setup.sh"
fi

# Helper: copy a config file to a dest, with backup
deploy() {
  local src="$1"; local dest="$2"
  if [[ -f "$src" ]]; then
    mkdir -p "$(dirname "$dest")"
    backup_if_exists "$dest"
    cp "$src" "$dest"
    ok "wrote ${dest/#$HOME/~}"
  else
    skip "$(basename "$src") (not present, skipping)"
  fi
}

# tmux config + plugin manager (TPM)
deploy "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" >/dev/null 2>&1 \
    && ok "installed TPM (tmux plugin manager)" \
    || fail "TPM clone failed"
else
  skip "TPM already installed"
fi
# Auto-install tmux plugins listed in tmux.conf
if [[ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]]; then
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 || true
  ok "installed tmux plugins"
fi

# lazygit
deploy "$SCRIPT_DIR/lazygit-config.yml" "$HOME/Library/Application Support/lazygit/config.yml"

# fastfetch
deploy "$SCRIPT_DIR/fastfetch.jsonc" "$HOME/.config/fastfetch/config.jsonc"

# git
deploy "$SCRIPT_DIR/gitconfig"        "$HOME/.gitconfig"
deploy "$SCRIPT_DIR/gitignore_global" "$HOME/.gitignore_global"

# bat: use the built-in '1337' theme — high-contrast cyberpunk syntax highlighting
if have bat; then
  mkdir -p "$(bat --config-dir)"
  cat > "$(bat --config-dir)/config" <<'BATCFG'
--theme="1337"
--style="numbers,changes,header"
--map-syntax "*.conf:INI"
BATCFG
  ok "wrote bat config (theme: 1337)"
fi

# neovim
if [[ -d "$SCRIPT_DIR/nvim" ]]; then
  backup_if_exists "$HOME/.config/nvim"
  rm -rf "$HOME/.config/nvim"
  mkdir -p "$HOME/.config"
  cp -R "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"
  ok "wrote ~/.config/nvim/"
else
  skip "nvim/ folder missing, skipping"
fi

# Aerospace (tiling WM)
deploy "$SCRIPT_DIR/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"

# Karabiner
deploy "$SCRIPT_DIR/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

# Ghostty
deploy "$SCRIPT_DIR/ghostty-config"   "$HOME/.config/ghostty/config"
deploy "$SCRIPT_DIR/ghostty-crt.glsl" "$HOME/.config/ghostty/shaders/crt.glsl"

# ── done ───────────────────────────────────────────────────────────────────
printf "\n${G}╔════════════════════════════════════════════════════════════╗${R}\n"
printf "${G}║${R}  ${B}${C}Setup complete. Open a fresh terminal to enjoy.${R}            ${G}║${R}\n"
printf "${G}╚════════════════════════════════════════════════════════════╝${R}\n\n"
printf "${D}Next steps:${R}\n"
printf "  • iTerm2 — Settings → Profiles → Text → font ${B}JetBrainsMono Nerd Font${R} 14pt; Colors → import ${B}iterm2-neon.itermcolors${R}.\n"
printf "  • Karabiner — open the app once to grant accessibility permissions; the Caps→Esc/Ctrl remap activates after.\n"
printf "  • Aerospace — open it once, accept accessibility prompt; ${B}alt-1..9${R} switches workspaces, ${B}alt-shift-c${R} reloads config.\n"
printf "  • Raycast — launch and replace Spotlight: Settings → General → set hotkey to ⌘-Space (and disable Spotlight's hotkey in System Settings → Keyboard → Shortcuts → Spotlight).\n"
printf "  • Ghostty — already themed with the CRT shader; first open will compile it.\n"
printf "  • Inside tmux, hit ${B}Ctrl-Space + I${R} to install plugins (one-time).\n"
printf "  • Open nvim once. Plugins will auto-install. Then ${B}:Mason${R} to manage language servers.\n"
printf "  • Run ${B}bash macos.sh${R} for the system-defaults pass (separate so you can read it first).\n"
printf "  • ${B}brew bundle dump --file=~/Brewfile --force${R} once happy, to snapshot your packages.\n\n"
