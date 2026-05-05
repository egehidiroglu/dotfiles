# evangelion-neon palette

Single source of truth for every config in this repo. Every dotfile references hex values from this table.

## Backgrounds

| Name | Hex | Use |
| --- | --- | --- |
| `bg_void`     | `#050510` | terminal background, true near-black with indigo undertone |
| `bg_alt`      | `#0d0d1f` | popups, status backgrounds, secondary surfaces |
| `bg_panel`    | `#1a1a3a` | panel/sidebar background (nvim-tree, lazygit panels) |
| `bg_select`   | `#2a1a4a` | selection background, subtly purple |

## Foregrounds

| Name | Hex | Use |
| --- | --- | --- |
| `fg_primary`  | `#e0e0ff` | main text, slight purple white |
| `fg_dim`      | `#6a6a8a` | comments, separators, inactive text |
| `fg_bright`   | `#ffffff` | pure white for emphasis |

## Accents — the punchy ones

| Name | Hex | Inspiration |
| --- | --- | --- |
| `eva_green`   | `#39ff14` | Eva-01 unit, classic CRT green, "the Matrix" |
| `eva_purple`  | `#b026ff` | Eva-01 body armor, AT field |
| `magenta`     | `#ff00ff` | pure CMYK magenta, vaporwave grid |
| `pink_hot`    | `#ff1493` | deep pink, neon tokyo signage |
| `cyan_electric`| `#00ffff` | terminal cyan, blade runner rain |
| `blue_signal` | `#0099ff` | ghost in the shell info-pulse |
| `orange_eva`  | `#ff6f00` | Eva-00 unit, warning lights |
| `yellow_electric` | `#ffea00` | DANGER screens, NERV alerts |
| `red_alert`   | `#ff1744` | "ABSOLUTE TERROR" red |

## ANSI palette (16 colors)

| Slot | Hex | Maps to |
| --- | --- | --- |
| 0  black   | `#1a1a2e` | dim text |
| 1  red     | `#ff1744` | errors, deletions |
| 2  green   | `#39ff14` | success, additions |
| 3  yellow  | `#ffea00` | warnings, modified |
| 4  blue    | `#0099ff` | info, branches |
| 5  magenta | `#ff00ff` | prompts, accents |
| 6  cyan    | `#00ffff` | strings, paths |
| 7  white   | `#c0c0e0` | normal text |
| 8  br black| `#4a4a6a` | UI chrome |
| 9  br red  | `#ff5252` | bright errors |
| 10 br grn  | `#5eff39` | bright success |
| 11 br yel  | `#fff04d` | bright warning |
| 12 br blu  | `#4dd9ff` | bright info |
| 13 br mag  | `#b026ff` | eva purple, prompt highlights |
| 14 br cyn  | `#4dffff` | bright cyan |
| 15 br wht  | `#ffffff` | pure white |

## Where each value is referenced

- `iterm2-neon.itermcolors` — full ANSI map + bg/fg/cursor
- `ghostty-config` — same map in `palette = N=#hex` form
- `starship.toml` — `[palettes.neon]` reuses these
- `zshrc` — `LS_COLORS`, `FZF_DEFAULT_OPTS`, autosuggestions style
- `tmux.conf` — status bar bg/fg/active/border
- `lazygit-config.yml` — gui.theme.* color refs
- `nvim` — uses `cyberdream.nvim` colorscheme (closely matches this palette out of the box)
- `gitconfig` — delta uses bat's `1337` theme (cyberpunk-style syntax highlighting)
- `bat` config — theme `1337`
