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
  read -p "==> Install ${bundle_name} bundle? [y/N] " reply
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

# 1. Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "==> Homebrew already installed"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Brew bundle (formulae + casks)
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

# 5. Generate bun completions (required by .zshrc)
if command -v bun &>/dev/null; then
  echo "==> Generating bun completions..."
  mkdir -p "$HOME/.bun"
  bun completions > "$HOME/.bun/_bun" 2>/dev/null || true
else
  echo "==> Skipping bun completions (bun not found)"
fi

# 6. ~/.zfunc directory
if [ ! -d "$HOME/.zfunc" ]; then
  echo "==> Creating ~/.zfunc"
  mkdir -p "$HOME/.zfunc"
else
  echo "==> ~/.zfunc already exists"
fi

# 7. vim-plug
PLUG_FILE="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG_FILE" ]; then
  echo "==> Installing vim-plug..."
  curl -fLo "$PLUG_FILE" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  echo "==> vim-plug already installed"
fi

# 8. Symlink dotfiles (optional)
echo ""
read -p "==> Symlink dotfiles? [y/N] " REPLY
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  DOTFILES=(.gitconfig .zshrc .p10k.zsh .gitignore_global .vimrc .npmrc)
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
    read -p "    Git name [Myles Borins]: " GIT_NAME
    GIT_NAME="${GIT_NAME:-Myles Borins}"
    read -p "    Git email [myles.borins@gmail.com]: " GIT_EMAIL
    GIT_EMAIL="${GIT_EMAIL:-myles.borins@gmail.com}"
    read -p "    Git username [mylesborins]: " GIT_USERNAME
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
fi

# 9. Install vim plugins (after .vimrc is in place)
if [ -f "$HOME/.vimrc" ]; then
  echo "==> Installing vim plugins..."
  vim -es -u "$HOME/.vimrc" +PlugInstall +qall 2>/dev/null || true

fi

# 10. Setup rustup toolchain
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
