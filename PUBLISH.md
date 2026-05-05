# Publish to a public GitHub repo

Run these once. The repo will live at `https://github.com/<your-user>/dotfiles`.

```bash
cd ~/Desktop/Coding/dotfiles

# Make sure git knows who you are
git config --global user.name  "Ege Hidiroglu"
git config --global user.email "egehdrgl@gmail.com"

# Make sure gh is logged in (only needed once per machine)
gh auth status || gh auth login

# Initialize, commit, create the public repo, push
git init -b main
git add .
git commit -m "feat: initial hacker-mode dotfiles"
gh repo create dotfiles --public --source=. --remote=origin --push
```

That's it. The repo is live and `origin/main` tracks your local main.

## On a new Mac later

```bash
git clone https://github.com/<your-user>/dotfiles ~/Desktop/Coding/dotfiles
cd ~/Desktop/Coding/dotfiles
bash setup.sh
bash macos.sh
```

## Subsequent updates

After tweaking a dotfile (say `~/.zshrc`) you'll want to copy the change back into the repo and push it. There's no symlink magic in this kit — `setup.sh` does plain copies — so the workflow is:

```bash
cd ~/Desktop/Coding/dotfiles
cp ~/.zshrc                          ./zshrc
cp ~/.config/starship.toml           ./starship.toml
cp ~/.tmux.conf                      ./tmux.conf
# ...etc

git add -A
git commit -m "chore: sync local tweaks"
git push
```

If you want symlinks instead of copies (so edits to `~/.zshrc` show up in the repo automatically), open an issue with yourself and I'll wire `stow` or a small `link.sh`.

## A note on safety

The `.gitignore` I dropped excludes `.env`, `*.key`, `id_rsa*`, `id_ed25519*`, and the `*.bak.*` snapshots `setup.sh` creates. You should still eyeball `git status` before each commit. If you ever paste a real API key into a config file, rotate the key — assume it's compromised once it touches a public repo.
