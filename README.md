# Ege's macOS hacker dotfiles

Self-contained kit that turns a fresh Apple Silicon Mac into a heavily-tuned dev machine. One audit script, one install script, plus configs for everything that touches the workflow: shell, prompt, terminals, tmux, neovim, lazygit, git, fastfetch, tiling WM, keyboard remaps, plus a CRT shader because life is short.

```bash
git clone https://github.com/<you>/dotfiles ~/dotfiles
cd ~/dotfiles
bash audit.sh         # see what's already installed
bash setup.sh         # install the rest + drop configs into ~
bash macos.sh         # apply system-defaults tweaks (separate, read it first)
```

## What's in the box

| File | Becomes | Purpose |
| --- | --- | --- |
| `audit.sh` | — | Read-only inventory. Prints what's installed, marks what's missing. |
| `setup.sh` | — | Idempotent installer. Homebrew + 30+ tools + drops every config below. |
| `macos.sh` | — | `defaults write` script. ~25 system tweaks. Reversible, separate so you can read it. |
| `zshrc` | `~/.zshrc` | Aliases, fzf, zoxide, fnm, plugins, starship, fastfetch banner. |
| `starship.toml` | `~/.config/starship.toml` | Neon prompt with git + language modules. |
| `tmux.conf` | `~/.tmux.conf` | Vim navigation, neon status bar, persistent sessions via tmux-resurrect. |
| `lazygit-config.yml` | `~/Library/Application Support/lazygit/config.yml` | git TUI with evangelion-neon palette. |
| `fastfetch.jsonc` | `~/.config/fastfetch/config.jsonc` | Neon system-info banner shown on new shells. |
| `gitconfig` | `~/.gitconfig` | Delta pager, conventional aliases, sane diff defaults. |
| `gitignore_global` | `~/.gitignore_global` | Global `.gitignore` (DS_Store, .env, editor junk). |
| `nvim/` | `~/.config/nvim/` | Lean Lua config: lazy.nvim, cyberdream colorscheme, Telescope, LSP+Mason, Treesitter, gitsigns, lualine. |
| `iterm2-neon.itermcolors` | imported manually | iTerm2 color preset (evangelion-neon — eva-green + magenta + cyan on near-black). |
| `ghostty-config` | `~/.config/ghostty/config` | Ghostty terminal w/ neon palette + CRT shader. |
| `ghostty-crt.glsl` | `~/.config/ghostty/shaders/crt.glsl` | Subtle scanlines + vignette + chromatic aberration. |
| `aerospace.toml` | `~/.config/aerospace/aerospace.toml` | i3-style tiling WM. Alt+1..9 workspaces, hjkl pane focus. |
| `karabiner.json` | `~/.config/karabiner/karabiner.json` | Caps→Esc/Ctrl, right-Cmd as Hyper key, Hyper+hjkl arrows. |
| `WALLPAPERS.md` | — | Curated sources for cyberpunk/Y2K/Tokyo wallpapers. |

## What gets installed

**CLI staples (Homebrew):** `git`, `gh`, `git-delta`, `fzf`, `ripgrep`, `fd`, `bat`, `eza`, `jq`, `yq`, `zoxide`, `tmux`, `neovim`, `lazygit`, `btop`, `tldr`, `tree`, `wget`, `httpie`, `fastfetch`, `starship`, `fnm`, `uv`, `rustup-init`, `go`, `zsh-autosuggestions`, `zsh-syntax-highlighting`. Plus fun: `cmatrix`, `pipes-sh`, `cbonsai`, `asciiquarium`.

**Apps (Casks):** iTerm2, Ghostty, Raycast, Aerospace, Karabiner-Elements. Fonts: JetBrainsMono Nerd Font, Fira Code Nerd Font, Monaspace.

**Languages:** Rust (rustup stable), Node (fnm + LTS), Go (brew), Python via brew + uv.

## After running setup.sh

A bunch of these need a one-time permission grant or hotkey:

1. **Karabiner** — open the app once, accept Accessibility prompt. The Caps Lock remap won't work until you do.
2. **Aerospace** — open it, accept the Accessibility prompt. Then `alt-1` switches to workspace 1, `alt-shift-c` reloads config.
3. **Raycast** — launch, set hotkey to ⌘-Space (System Settings → Keyboard → Shortcuts → Spotlight → uncheck Spotlight's hotkey first).
4. **iTerm2** — Settings → Profiles → Text → font `JetBrainsMono Nerd Font` 14pt. Colors → Color Presets… → Import `iterm2-neon.itermcolors`, then load it.
5. **Ghostty** — already themed. First open compiles the CRT shader.
6. **tmux** — inside a tmux session, `Ctrl-Space + I` once to install plugins.
7. **nvim** — open it once. lazy.nvim auto-installs everything. `:Mason` to manage language servers.

## Re-running

`setup.sh` is idempotent. It detects existing installs (skip), backs up dotfiles before overwriting (`<file>.bak.YYYYMMDDHHMMSS`), and never prompts. Edit it and re-run any time.

## Layout

```
dotfiles/
├── audit.sh          ← inventory
├── setup.sh          ← installer
├── macos.sh          ← system defaults
├── zshrc / starship.toml / tmux.conf / etc.   ← top-level configs
├── nvim/             ← neovim config tree
└── README.md / WALLPAPERS.md
```

## What's NOT included

- **Xcode** — 16+ GB, App Store only. `audit.sh` checks for it; install when you need it.
- **Docker / OrbStack** — taste call. Add to `setup.sh` when you decide.
- **AWS / gcloud / kubectl** — only if you need them.
- **Wallpapers** — see `WALLPAPERS.md` for sources; the actual files are personal.

## Cheatsheet

```
ls         eza w/ icons + group dirs first
la         eza -la with git status
lt         eza tree, depth 2
cat <f>    bat
grep <p>   ripgrep
find <p>   fd
vim        nvim
lg         lazygit
gs / gd    git status / git diff
gpl        git pull --rebase --autostash
matrix     cmatrix
bonsai     cbonsai
aquarium   asciiquarium

Ctrl-R     fzf history search
Ctrl-T     fzf file picker
Alt-C      fzf cd picker
cd <part>  zoxide jump

Ctrl-Space     tmux prefix
prefix + |     split right
prefix + -     split down
prefix + hjkl  navigate panes (vim)
prefix + I     install tmux plugins (one-time)

Alt-1..9         Aerospace workspaces
Alt-hjkl         focus pane
Alt-shift-hjkl   move window
Alt-shift-c      reload Aerospace config

<space>ff  Telescope find files (in nvim)
<space>fg  Telescope live grep
<space>e   nvim-tree toggle
<space>gg  lazygit from nvim
gd / K     LSP go-to-def / hover
```
