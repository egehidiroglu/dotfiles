# ──────────────────────────────────────────────────────────────────────────
#  ~/.zshrc  —  hacker aesthetic, sane defaults
#  Generated for Ege. Re-runnable; backs up your prior file.
# ──────────────────────────────────────────────────────────────────────────

# ── PATH / Homebrew ───────────────────────────────────────────────────────
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# ── History (big, deduped, shared between tabs) ───────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt SHARE_HISTORY INC_APPEND_HISTORY EXTENDED_HISTORY

# ── Smart completion ──────────────────────────────────────────────────────
autoload -Uz compinit && compinit -u
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── evangelion-neon LSCOLORS / LS_COLORS ──────────────────────────────────
# di=cyan dir, ln=magenta link, ex=green exec, pi=yellow pipe, so=eva-purple socket
export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagaced"
export LS_COLORS="di=38;2;0;255;255:ln=38;2;255;0;255:so=38;2;176;38;255:pi=38;2;255;234;0:ex=38;2;57;255;20:bd=38;2;255;111;0:cd=38;2;255;111;0:su=38;2;255;23;68:sg=38;2;255;23;68:tw=38;2;0;255;255:ow=38;2;0;255;255"

# ── Aliases: modern replacements ──────────────────────────────────────────
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first --icons=auto'
  alias la='eza -la --group-directories-first --icons=auto --git'
  alias lt='eza --tree --level=2 --icons=auto'
  alias ll='eza -l --group-directories-first --icons=auto --git'
fi
command -v bat   >/dev/null 2>&1 && alias cat='bat --paging=never --style=plain'
command -v rg    >/dev/null 2>&1 && alias grep='rg'
command -v fd    >/dev/null 2>&1 && alias find='fd'
command -v nvim  >/dev/null 2>&1 && alias vim='nvim' && export EDITOR=nvim && export VISUAL=nvim
command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'

# Git muscle-memory aliases
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate --all -30'
alias gco='git checkout'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull --rebase --autostash'

# Safety + convenience
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -p'
alias please='sudo $(fc -ln -1)'   # rerun last command as root
alias ip='curl -s https://api.ipify.org && echo'
alias weather='curl -s "wttr.in/?format=3"'

# ── ports: what's listening, and which folder it runs from ────────────────
function ports {
  local port pid proc addr cwd containers
  printf '%-6s %-7s %-20s %-18s %s\n' PORT PID PROCESS ADDRESS FOLDER
  lsof +c 0 -nP -iTCP -sTCP:LISTEN 2>/dev/null \
    | awk 'NR>1 {n=split($9,a,":"); print a[n], $2, $1, $9}' | sort -u | sort -n \
    | while read -r port pid proc addr; do
        cwd=$(lsof -a -d cwd -p "$pid" -Fn 2>/dev/null | awk '/^n/ {print substr($0,2)}')
        printf '%-6s %-7s %-20s %-18s %s\n' "$port" "$pid" "${proc//\\x20/ }" "$addr" "${(D)cwd}"
      done
  # Docker's ports all show up as com.docker.backend, so name the containers too.
  containers=$(docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}' 2>/dev/null)
  if [[ -n "$containers" ]]; then
    printf '\n%s\n' "$containers"
  fi
}

# ── fzf integrations ──────────────────────────────────────────────────────
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"
export FZF_DEFAULT_OPTS="
  --height=40% --layout=reverse --border=rounded --info=inline
  --color=fg:#e0e0ff,bg:-1,hl:#ff00ff
  --color=fg+:#ffffff,bg+:#1a1a3a,hl+:#39ff14
  --color=info:#00ffff,prompt:#b026ff,pointer:#ff00ff
  --color=marker:#39ff14,spinner:#b026ff,header:#ffea00
  --color=border:#b026ff
"
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# ── zoxide: cd that learns ────────────────────────────────────────────────
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# ── fnm (Node) ────────────────────────────────────────────────────────────
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ── pyenv (if installed) ──────────────────────────────────────────────────
if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# ── Plugins: autosuggestions + syntax highlighting (must be last-ish) ─────
BREW_PREFIX="$(brew --prefix 2>/dev/null || echo /opt/homebrew)"
[[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] \
  && source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
  && source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6a6a8a,italic'

# ── starship prompt ───────────────────────────────────────────────────────
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ── Banner on a new interactive shell ─────────────────────────────────────
# fastfetch if installed, otherwise a tiny one-liner.
if [[ -o interactive ]] && [[ -z "$ZSH_BANNER_SHOWN" ]]; then
  if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
  else
    # 24-bit RGB block: magenta → eva-purple gradient + cyan greeting
    printf '\033[38;2;255;0;255m▟\033[38;2;192;38;255m▙\033[38;2;176;38;255m▟\033[38;2;57;255;20m▙ \033[38;2;0;255;255mwelcome back, \033[1m%s\033[0m\033[38;2;0;255;255m — %s\033[0m\n' \
      "${USER}" "$(date '+%a %H:%M')"
  fi
  export ZSH_BANNER_SHOWN=1
fi

# ── Pure unhinged fun aliases ─────────────────────────────────────────────
command -v cmatrix      >/dev/null 2>&1 && alias matrix='cmatrix -ab -C cyan'
command -v pipes.sh     >/dev/null 2>&1 && alias pipes='pipes.sh -t 2 -p 4 -f 75'
command -v cbonsai      >/dev/null 2>&1 && alias bonsai='cbonsai -l -t 0.05'
command -v asciiquarium >/dev/null 2>&1 && alias aquarium='asciiquarium'
