#!/bin/bash
#
# setup.sh — Set up a new macOS machine
# Homebrew-only. Safe to re-run.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Setting up machine"

# 1. Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "==> Homebrew already installed"
fi

# 2. Brew bundle (formulae + casks)
echo "==> Running brew bundle..."
brew bundle --file="$SCRIPT_DIR/Brewfile"

# 3. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "==> Oh My Zsh already installed"
fi

# 4. evalcache plugin
EVALCACHE_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/evalcache"
if [ ! -d "$EVALCACHE_DIR" ]; then
  echo "==> Installing evalcache plugin..."
  git clone https://github.com/mroth/evalcache "$EVALCACHE_DIR"
else
  echo "==> evalcache plugin already installed"
fi

# 5. bun
if ! command -v bun &>/dev/null; then
  echo "==> Installing bun..."
  curl -fsSL https://bun.sh/install | bash
else
  echo "==> bun already installed"
fi

# 6. ~/.zfunc directory
if [ ! -d "$HOME/.zfunc" ]; then
  echo "==> Creating ~/.zfunc"
  mkdir -p "$HOME/.zfunc"
else
  echo "==> ~/.zfunc already exists"
fi

echo ""
echo "Done! Open a new terminal to pick up changes."
echo "Run 'p10k configure' if you need to set up your prompt theme."
