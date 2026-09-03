#!/usr/bin/env bash
set -euo pipefail

# Resolve where this repo was cloned. GitHub Codespaces clones the dotfiles
# repo to ~/codespace-dotfiles when the repo is named "codespace-dotfiles".
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()    { echo "[INFO]  $*"; }
success() { echo "[OK]    $*"; }
skip()    { echo "[SKIP]  $*"; }
note()    { echo "[NOTE]  $*"; }

symlink() {
  local src="$1" dst="$2"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    info "Backing up existing $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    skip "$dst already linked"
  else
    ln -sf "$src" "$dst"
    success "Linked $dst → $src"
  fi
}

# ── 1. Shell ────────────────────────────────────────────────────────────────

# zsh
if ! command -v zsh &>/dev/null; then
  info "Installing zsh..."
  sudo apt-get update -q && sudo apt-get install -y zsh
  success "zsh installed ($(zsh --version))"
else
  skip "zsh already installed ($(zsh --version))"
fi

# oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing oh-my-zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  success "oh-my-zsh installed"
else
  skip "oh-my-zsh already installed"
fi

OMZ_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Powerlevel10k
if [[ ! -d "$OMZ_CUSTOM/themes/powerlevel10k" ]]; then
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$OMZ_CUSTOM/themes/powerlevel10k"
  success "Powerlevel10k installed"
else
  skip "Powerlevel10k already installed"
fi

# zsh-autosuggestions
if [[ ! -d "$OMZ_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$OMZ_CUSTOM/plugins/zsh-autosuggestions"
  success "zsh-autosuggestions installed"
else
  skip "zsh-autosuggestions already installed"
fi

# zsh-autocomplete (standalone, sourced directly from ~/zsh-autocomplete)
if [[ ! -d "$HOME/zsh-autocomplete" ]]; then
  info "Installing zsh-autocomplete..."
  git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete.git \
    "$HOME/zsh-autocomplete"
  success "zsh-autocomplete installed"
else
  skip "zsh-autocomplete already installed"
fi

# ── 2. CLI tools ─────────────────────────────────────────────────────────────

# ripgrep (available in apt)
if ! command -v rg &>/dev/null; then
  info "Installing ripgrep..."
  sudo apt-get install -y ripgrep
  success "ripgrep installed ($(rg --version | head -1))"
else
  skip "ripgrep already installed ($(rg --version | head -1))"
fi

# autojump (available in apt)
if ! command -v autojump &>/dev/null; then
  info "Installing autojump..."
  sudo apt-get install -y autojump
  success "autojump installed"
else
  skip "autojump already installed"
fi

# fzf (available in apt, or via git clone)
if ! command -v fzf &>/dev/null; then
  info "Installing fzf..."
  if apt-cache show fzf &>/dev/null 2>&1; then
    sudo apt-get install -y fzf
  else
    [[ ! -d "$HOME/.fzf" ]] && git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --no-update-rc
  fi
  success "fzf installed ($(fzf --version))"
else
  skip "fzf already installed ($(fzf --version))"
fi

# bat (binary download — apt version is often outdated)
if ! command -v bat &>/dev/null; then
  info "Installing bat..."
  BAT_VERSION="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/sharkdp/bat/releases/latest | sed 's|.*/v||')"
  BAT_URL="https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  BAT_TMP="$(mktemp -d)"
  curl -fsSL "$BAT_URL" | tar -xz -C "$BAT_TMP"
  sudo mv "$BAT_TMP/bat-v${BAT_VERSION}-x86_64-unknown-linux-musl/bat" /usr/local/bin/bat
  rm -rf "$BAT_TMP"
  success "bat installed ($(bat --version))"
else
  skip "bat already installed ($(bat --version))"
fi

# fd (binary download)
if ! command -v fd &>/dev/null; then
  info "Installing fd..."
  FD_VERSION="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/sharkdp/fd/releases/latest | sed 's|.*/v||')"
  FD_URL="https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  FD_TMP="$(mktemp -d)"
  curl -fsSL "$FD_URL" | tar -xz -C "$FD_TMP"
  sudo mv "$FD_TMP/fd-v${FD_VERSION}-x86_64-unknown-linux-musl/fd" /usr/local/bin/fd
  rm -rf "$FD_TMP"
  success "fd installed ($(fd --version))"
else
  skip "fd already installed ($(fd --version))"
fi

# eza (binary download)
if ! command -v eza &>/dev/null; then
  info "Installing eza..."
  EZA_VERSION="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/eza-community/eza/releases/latest | sed 's|.*/v||')"
  EZA_URL="https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_x86_64-unknown-linux-musl.tar.gz"
  EZA_TMP="$(mktemp -d)"
  curl -fsSL "$EZA_URL" | tar -xz -C "$EZA_TMP"
  sudo mv "$EZA_TMP/eza" /usr/local/bin/eza
  rm -rf "$EZA_TMP"
  success "eza installed ($(eza --version | head -1))"
else
  skip "eza already installed ($(eza --version | head -1))"
fi

# delta (binary download)
if ! command -v delta &>/dev/null; then
  info "Installing delta..."
  DELTA_VERSION="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/dandavison/delta/releases/latest | sed 's|.*/||')"
  DELTA_URL="https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  DELTA_TMP="$(mktemp -d)"
  curl -fsSL "$DELTA_URL" | tar -xz -C "$DELTA_TMP"
  sudo mv "$DELTA_TMP/delta-${DELTA_VERSION}-x86_64-unknown-linux-musl/delta" /usr/local/bin/delta
  rm -rf "$DELTA_TMP"
  success "delta installed ($(delta --version))"
else
  skip "delta already installed ($(delta --version))"
fi

# lazygit (binary download)
if ! command -v lazygit &>/dev/null; then
  info "Installing lazygit..."
  LG_VERSION="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/jesseduffield/lazygit/releases/latest | sed 's|.*/v||')"
  LG_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LG_VERSION}/lazygit_${LG_VERSION}_Linux_x86_64.tar.gz"
  LG_TMP="$(mktemp -d)"
  curl -fsSL "$LG_URL" | tar -xz -C "$LG_TMP"
  sudo mv "$LG_TMP/lazygit" /usr/local/bin/lazygit
  rm -rf "$LG_TMP"
  success "lazygit installed ($(lazygit --version))"
else
  skip "lazygit already installed ($(lazygit --version))"
fi

# ── 3. Atuin (cross-codespace shell history sync) ────────────────────────────

if [[ ! -f "$HOME/.atuin/bin/atuin" ]]; then
  info "Installing atuin..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  success "atuin installed"
else
  skip "atuin already installed ($("$HOME/.atuin/bin/atuin" --version))"
fi

# ── 4. Clone dotfiles repo (for Claude config) ───────────────────────────────

if [[ ! -d "$HOME/dotfiles" ]]; then
  info "Cloning AlejandroCamba/dotfiles into ~/dotfiles..."
  git clone https://github.com/AlejandroCamba/dotfiles.git "$HOME/dotfiles"
  success "dotfiles cloned"
else
  skip "~/dotfiles already exists"
fi

# ── 5. Symlink Claude config from ~/dotfiles ─────────────────────────────────

mkdir -p "$HOME/.claude"
symlink "$HOME/dotfiles/claude/agents"       "$HOME/.claude/agents"
symlink "$HOME/dotfiles/claude/skills"       "$HOME/.claude/skills"
symlink "$HOME/dotfiles/claude/hooks"        "$HOME/.claude/hooks"
symlink "$HOME/dotfiles/claude/commands"     "$HOME/.claude/commands"
symlink "$HOME/dotfiles/claude/CLAUDE.md"    "$HOME/.claude/CLAUDE.md"
symlink "$HOME/dotfiles/claude/settings.json" "$HOME/.claude/settings.json"

# ── 6. Symlink shell config from this repo ───────────────────────────────────

symlink "$REPO_DIR/.zshrc"    "$HOME/.zshrc"
symlink "$REPO_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
symlink "$REPO_DIR/.gitconfig" "$HOME/.gitconfig"

# ── 7. Set zsh as default shell ──────────────────────────────────────────────

if [[ "$SHELL" != "$(command -v zsh)" ]]; then
  info "Changing default shell to zsh..."
  chsh -s "$(command -v zsh)"
  success "Default shell changed — re-login or start a new session to take effect"
else
  skip "zsh is already the default shell"
fi

# ── 8. Done ──────────────────────────────────────────────────────────────────

echo ""
echo "================================================================="
echo "  Codespace dotfiles installed."
echo "================================================================="
echo ""
echo "Next steps:"
echo "  1. Start a new terminal (or run: exec zsh) to load the shell config."
echo "  2. Set up atuin history sync (one-time, if not done on this account):"
echo "       atuin register -u <username> -e <email> -p <password>"
echo "       # or if already registered:"
echo "       atuin login -u <username> -p <password>"
echo "       atuin sync"
echo "  3. If BLUEBOX_KB_PAT is not already set as a Codespace secret,"
echo "     add it at: github.com/settings/codespaces (Secrets section)."
echo ""
