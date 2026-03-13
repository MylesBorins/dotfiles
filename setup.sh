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

# 7. vim-plug + plugins
PLUG_FILE="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG_FILE" ]; then
  echo "==> Installing vim-plug..."
  curl -fLo "$PLUG_FILE" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  echo "==> vim-plug already installed"
fi
if [ -f "$HOME/.vimrc" ]; then
  echo "==> Installing vim plugins..."
  vim +PlugInstall +qall
fi

# 8. Symlink dotfiles (optional)
echo ""
read -p "==> Symlink dotfiles? [y/N] " REPLY
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  # Git identity
  read -p "    Git name [Myles Borins]: " GIT_NAME
  GIT_NAME="${GIT_NAME:-Myles Borins}"
  read -p "    Git email [myles.borins@gmail.com]: " GIT_EMAIL
  GIT_EMAIL="${GIT_EMAIL:-myles.borins@gmail.com}"
  read -p "    Git username [mylesborins]: " GIT_USERNAME
  GIT_USERNAME="${GIT_USERNAME:-mylesborins}"

  # Template .gitconfig
  sed \
    -e "s/name = Myles Borins/name = $GIT_NAME/" \
    -e "s/email = myles.borins@gmail.com/email = $GIT_EMAIL/" \
    -e "s/username = mylesborins/username = $GIT_USERNAME/" \
    -e "s/user = mylesborins/user = $GIT_USERNAME/" \
    "$SCRIPT_DIR/.gitconfig" > "$SCRIPT_DIR/.gitconfig.local"

  DOTFILES=(.zshrc .p10k.zsh .gitignore_global .vimrc .npmrc)
  for f in "${DOTFILES[@]}"; do
    if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
      echo "    Backing up ~/$f to ~/$f.bak"
      mv "$HOME/$f" "$HOME/$f.bak"
    fi
    ln -sf "$SCRIPT_DIR/$f" "$HOME/$f"
    echo "    Linked ~/$f"
  done

  # .gitconfig uses the templated version
  if [ -e "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
    echo "    Backing up ~/.gitconfig to ~/.gitconfig.bak"
    mv "$HOME/.gitconfig" "$HOME/.gitconfig.bak"
  fi
  mv "$SCRIPT_DIR/.gitconfig.local" "$HOME/.gitconfig"
  echo "    Wrote ~/.gitconfig"
fi

echo ""
echo "Done! Open a new terminal to pick up changes."
echo "Run 'p10k configure' if you need to set up your prompt theme."
