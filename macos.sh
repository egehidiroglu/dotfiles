#!/usr/bin/env bash
# macos.sh — opinionated `defaults write` tweaks for a developer's Mac.
# Reversible (every key has a default Apple value you can restore).
# Re-runnable: `defaults write` is idempotent.
#
# Usage:  bash macos.sh
# After: log out + back in (or just reboot) for everything to take.

set -u

ok()   { printf "  \033[38;5;46m✓\033[0m %s\n" "$1"; }
note() { printf "  \033[38;5;226m·\033[0m %s\n" "$1"; }
section() { printf "\n\033[38;5;201m▸\033[0m \033[1m%s\033[0m\n" "$1"; }

# Ask for sudo upfront, keep it alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ── Finder ────────────────────────────────────────────────────────────────
section "Finder"
defaults write com.apple.finder AppleShowAllFiles -bool true
ok "show hidden files"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
ok "show all file extensions"
defaults write com.apple.finder ShowPathbar -bool true
ok "show path bar"
defaults write com.apple.finder ShowStatusBar -bool true
ok "show status bar"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
ok "default to list view"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
ok "no extension-change warning"
defaults write com.apple.finder _FXSortFoldersFirst -bool true
ok "sort folders first"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
ok "new windows open ~"
defaults write com.apple.finder QuitMenuItem -bool true
ok "Cmd+Q quits Finder"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
ok "no .DS_Store on network volumes"

# ── Dock ──────────────────────────────────────────────────────────────────
section "Dock"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.4
defaults write com.apple.dock autohide-delay -float 0
ok "Dock autohides instantly"
defaults write com.apple.dock tilesize -int 44
ok "smaller Dock tiles"
defaults write com.apple.dock magnification -bool false
ok "no magnification"
defaults write com.apple.dock mineffect -string "scale"
ok "minimize with scale (faster than genie)"
defaults write com.apple.dock mru-spaces -bool false
ok "don't reorder Spaces by use"
defaults write com.apple.dock show-recents -bool false
ok "no recent apps in Dock"
defaults write com.apple.dock launchanim -bool false
ok "no app launch bouncing"

# ── Mission Control & Spaces ──────────────────────────────────────────────
section "Mission Control"
defaults write com.apple.dock expose-animation-duration -float 0.12
ok "snappier Mission Control"

# ── Screenshots ───────────────────────────────────────────────────────────
section "Screenshots"
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
ok "screenshots → ~/Pictures/Screenshots"
defaults write com.apple.screencapture type -string "png"
ok "PNG format"
defaults write com.apple.screencapture disable-shadow -bool true
ok "no window shadow on screenshots"
defaults write com.apple.screencapture include-date -bool true
ok "include date in filename"

# ── Keyboard ──────────────────────────────────────────────────────────────
section "Keyboard"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
ok "key repeat instead of accent menu (vim-friendly)"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
ok "fast key repeat"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
ok "all auto-correct/substitution off"

# ── Trackpad ──────────────────────────────────────────────────────────────
section "Trackpad"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
ok "tap to click"

# ── Save dialogs / printing ───────────────────────────────────────────────
section "Save dialogs"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
ok "save dialogs expanded by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
ok "print dialogs expanded by default"

# ── Safari ────────────────────────────────────────────────────────────────
section "Safari (developer mode)"
defaults write com.apple.Safari IncludeDevelopMenu -bool true 2>/dev/null && ok "Develop menu enabled" || note "Safari preferences locked, skipped"
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true 2>/dev/null
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true 2>/dev/null

# ── Misc developer niceties ───────────────────────────────────────────────
section "Misc"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
ok "dark mode (skipped if already)"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
ok "instant window resize"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
ok "no window open/close animations"
defaults write com.apple.LaunchServices LSQuarantine -bool false
ok "no 'are you sure you want to open this' for downloaded apps"
defaults write com.apple.helpviewer DevMode -bool true
ok "macOS Help windows can lose focus"

# ── Apply: kick the affected apps ─────────────────────────────────────────
section "Applying — restarting Finder, Dock, SystemUIServer"
killall Finder         2>/dev/null || true
killall Dock           2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

printf "\n\033[38;5;46m✓ Done.\033[0m \033[2mLog out and back in (or reboot) to make sure everything sticks.\033[0m\n\n"
