#!/bin/bash
#
# setup.sh — Set up a new macOS machine
# Safe to re-run.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_APPS=""
INSTALL_EXTRAS=""

usage() {
  cat <<EOF
Usage: ./setup.sh [--apps] [--extras] [--all]

  --apps      Install Brewfile.apps
  --extras    Install Brewfile.extras
  --all       Install both optional bundles
EOF
}

prompt_for_bundle() {
  local bundle_name="$1"
  local reply
  echo ""
  read -r -p "==> Install ${bundle_name} bundle? [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

run_brew_bundle() {
  local brewfile="$1"
  local label="$2"

  if [ -f "$brewfile" ]; then
    echo "==> Running brew bundle (${label})..."
    brew bundle --file="$brewfile"
  fi
}

for arg in "$@"; do
  case "$arg" in
    --apps)
      INSTALL_APPS=1
      ;;
    --extras)
      INSTALL_EXTRAS=1
      ;;
    --all)
      INSTALL_APPS=1
      INSTALL_EXTRAS=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      usage
      exit 1
      ;;
  esac
done

echo "==> Setting up machine"

# 1. Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "==> Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "    Waiting for installation to complete (this may take a few minutes)..."
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  echo "==> Xcode Command Line Tools installed"
else
  echo "==> Xcode Command Line Tools already installed"
fi

# 2. Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "==> Homebrew already installed"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# 3. Brew bundle (formulae + casks)
run_brew_bundle "$SCRIPT_DIR/Brewfile" "base"

if [ -z "$INSTALL_APPS" ] && [ -f "$SCRIPT_DIR/Brewfile.apps" ]; then
  if prompt_for_bundle "apps"; then
    INSTALL_APPS=1
  else
    INSTALL_APPS=0
  fi
fi

if [ "$INSTALL_APPS" = "1" ]; then
  run_brew_bundle "$SCRIPT_DIR/Brewfile.apps" "apps"
fi

if [ -z "$INSTALL_EXTRAS" ] && [ -f "$SCRIPT_DIR/Brewfile.extras" ]; then
  if prompt_for_bundle "extras"; then
    INSTALL_EXTRAS=1
  else
    INSTALL_EXTRAS=0
  fi
fi

if [ "$INSTALL_EXTRAS" = "1" ]; then
  run_brew_bundle "$SCRIPT_DIR/Brewfile.extras" "extras"
fi

# 4. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "==> Oh My Zsh already installed"
fi

# 5. evalcache plugin
EVALCACHE_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/evalcache"
if [ ! -d "$EVALCACHE_DIR" ]; then
  echo "==> Installing evalcache plugin..."
  git clone https://github.com/mroth/evalcache "$EVALCACHE_DIR"
else
  echo "==> evalcache plugin already installed"
fi

# 6. Generate bun completions (required by .zshrc)
if command -v bun &>/dev/null; then
  echo "==> Generating bun completions..."
  mkdir -p "$HOME/.bun"
  bun completions > "$HOME/.bun/_bun" 2>/dev/null || true
else
  echo "==> Skipping bun completions (bun not found)"
fi

# 7. ~/.zfunc directory
if [ ! -d "$HOME/.zfunc" ]; then
  echo "==> Creating ~/.zfunc"
  mkdir -p "$HOME/.zfunc"
else
  echo "==> ~/.zfunc already exists"
fi

# 8. vim-plug
PLUG_FILE="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG_FILE" ]; then
  echo "==> Installing vim-plug..."
  curl -fLo "$PLUG_FILE" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  echo "==> vim-plug already installed"
fi

# 9. Symlink dotfiles (optional)
echo ""
read -r -p "==> Symlink dotfiles? [y/N] " REPLY
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  DOTFILES=(.gitconfig .zshrc .p10k.zsh .gitignore_global .vimrc .npmrc .tmux.conf)
  for f in "${DOTFILES[@]}"; do
    if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
      echo "    Backing up ~/$f to ~/$f.bak"
      mv "$HOME/$f" "$HOME/$f.bak"
    fi
    ln -sf "$SCRIPT_DIR/$f" "$HOME/$f"
    echo "    Linked ~/$f"
  done

  if [ -e "$HOME/.gitconfig.local" ]; then
    echo "    Keeping existing ~/.gitconfig.local"
  else
    read -r -p "    Git name [Myles Borins]: " GIT_NAME
    GIT_NAME="${GIT_NAME:-Myles Borins}"
    read -r -p "    Git email [myles.borins@gmail.com]: " GIT_EMAIL
    GIT_EMAIL="${GIT_EMAIL:-myles.borins@gmail.com}"
    read -r -p "    Git username [mylesborins]: " GIT_USERNAME
    GIT_USERNAME="${GIT_USERNAME:-mylesborins}"

    cat > "$HOME/.gitconfig.local" <<EOF
[user]
  name = $GIT_NAME
  email = $GIT_EMAIL
  username = $GIT_USERNAME
  # signingkey = YOUR_SIGNING_KEY
[github]
  user = $GIT_USERNAME

# Example folder-specific override:
# [includeIf "gitdir:~/src/personal/"]
#   path = ~/.gitconfig.personal

# Example ~/.gitconfig.personal:
# [user]
#   name = $GIT_NAME
#   email = you@example.com
#   username = yourusername
# [github]
#   user = yourusername
EOF
    echo "    Wrote ~/.gitconfig.local"
  fi

  if [ -e "$HOME/.zshrc.local" ]; then
    echo "    Keeping existing ~/.zshrc.local"
  else
    cat > "$HOME/.zshrc.local" <<'EOF'
# ~/.zshrc.local — Machine-specific shell config (not checked in)
# Sourced at the end of .zshrc — exports and aliases here override defaults.
#
# Examples:
#   export EDITOR="vim"
#   export PATH="$HOME/my-tools/bin:$PATH"
#   alias k="kubectl"
#   source ~/.work-env.sh
EOF
    echo "    Wrote ~/.zshrc.local"
  fi
fi

# 10. Install vim plugins (after .vimrc is in place)
if [ -f "$HOME/.vimrc" ]; then
  echo "==> Installing vim plugins..."
  vim -es -u "$HOME/.vimrc" +PlugInstall +qall 2>/dev/null || true

fi

# 11. Setup rustup toolchain
if ! command -v rustup &>/dev/null; then
  echo "==> rustup not found, skipping toolchain install"
elif ! rustup toolchain list | grep -q stable; then
  echo "==> Installing Rust stable toolchain..."
  rustup toolchain install stable --no-self-update
else
  echo "==> Rust toolchain already installed"
fi

echo ""
echo "Done! Open a new terminal to pick up changes."
echo "Run 'p10k configure' if you need to set up your prompt theme."
echo "If you installed apps, set iTerm2's font to 'JetBrainsMono Nerd Font' for the best prompt rendering."
