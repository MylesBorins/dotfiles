# dotfiles

Personal macOS-first dotfiles and bootstrap scripts.

## What's here

- primary shell setup in `.zshrc`
- generated Powerlevel10k config in `.p10k.zsh`
- minimal legacy Bash fallback in `.bash_profile`
- Git, Vim, npm, tmux, and lftp config (plus a legacy `.screenrc`)
- Homebrew bundles for core, apps, and extras installs
- `setup.sh` to bootstrap a fresh machine

## Bootstrapping a machine

Run the base setup:

- `./setup.sh`

With no bundle flags, `setup.sh` installs the core bundle and then interactively asks whether to install `apps` and `extras`.

Optional bundle flags:

- `./setup.sh --apps`
- `./setup.sh --extras`
- `./setup.sh --all`

The script will:

- install Homebrew if needed
- install the base `Brewfile`
- optionally install `Brewfile.apps` and/or `Brewfile.extras`
- install Oh My Zsh
- install the `evalcache` plugin used by `.zshrc`
- generate Bun completions at `~/.bun/_bun`
- install `vim-plug`
- optionally symlink the common dotfiles into `$HOME`
- install Vim plugins
- install the Rust stable toolchain if `rustup` is available

## Symlinked by setup

If you opt in, `setup.sh` links:

- `.gitconfig`
- `.zshrc`
- `.p10k.zsh`
- `.gitignore_global`
- `.vimrc`
- `.npmrc`
- `.tmux.conf`

If `~/.gitconfig.local` does not already exist, `setup.sh` creates it with your Git identity and a commented `includeIf` example for folder-specific overrides.

These are intentionally **not** auto-linked right now:

- `.bash_profile` (legacy fallback)
- `.screenrc` (legacy reference)
- `.lftprc`

## Notes

- This repo is intentionally tuned for Apple Silicon macOS and assumes Homebrew lives at `/opt/homebrew`.
- `.p10k.zsh` is generated; use `p10k configure` if you want to rework the prompt.
- Powerlevel10k is configured for Nerd Font glyphs; `Brewfile.apps` installs `font-jetbrains-mono-nerd-font`, but you still need to select it in your terminal profile.
- Local editor defaults are `code -w`; SSH sessions fall back to `vim`.
- Shared Git behavior lives in repo-managed `.gitconfig`; machine-specific identity and overrides live in `~/.gitconfig.local`.
- `tree` is provided via the alias `eza --tree`.

## Prompt font setup

If you install `Brewfile.apps`, JetBrains Mono Nerd Font is installed for you.

To make Powerlevel10k render correctly in iTerm2:

- open `iTerm2` → `Settings` → `Profiles` → `Text`
- enable the regular font picker
- choose `JetBrainsMono Nerd Font`
- open a new terminal tab/window

If icons still look wrong, run `p10k configure` and let it re-detect your terminal/font setup.

## CLI tools included

- `direnv` — auto-load project env vars from `.envrc`; use `direnv allow` after creating or changing a file.
- `fzf` — fuzzy finder; common bindings are `Ctrl-R` for history, `Ctrl-T` for files, and `Alt-C` for directories.
- `zoxide` — smarter directory jumping; use `z <name>` or `zi` for interactive selection.
- `tmux` — terminal multiplexer; with the Oh My Zsh plugin you get helpers like `tl`, `ts <name>`, and `ta <name>`.
- `shellcheck` — shell linter; run `shellcheck setup.sh .bash_profile` when editing shell code.
- `fd` — a friendlier `find`; try `fd foo` or `fd -t d src`.
- `delta` — better Git diffs; it is configured as the default Git pager.
- `yq` — `jq`-style querying for YAML; useful for CI/config files.
- `btop` — system monitor; this is the preferred replacement for `htop`.

## Vim additions

- `vim-fugitive` for Git integration inside Vim
- `vim-surround` and `vim-repeat` for fast editing ergonomics
- `editorconfig-vim` for per-project editor settings
- `fzf.vim` for `:Files`, `:Buffers`, and `:Rg`

Useful mappings:

- `Ctrl-N` — toggle NERDTree
- `Ctrl-P` — fuzzy-find files
- `\b` — list open buffers
- `\rg` — start an `:Rg` search
- `\t` — open a terminal split below the current window
- `\a` — ask tmux to split a new pane below for an agent/shell (when Vim is running inside tmux)

## tmux defaults

`setup.sh` now links `.tmux.conf`, which provides a small default config with:

- mouse support
- 5k lines of scrollback
- vi-style copy-mode keys
- 1-based window/pane numbering
- a simple bottom status line inspired by the legacy `screen` config

## Optional bundle layout

- `Brewfile` — core tooling plus must-have apps like `iterm2` and `rectangle`
- `Brewfile.apps` — GUI apps you generally want, plus the JetBrains Mono Nerd Font for Powerlevel10k
- `Brewfile.extras` — optional fun/media/AI extras and extra apps like `cursor`

This split keeps the base install small, lets you skip Homebrew-managed GUI apps on corporate machines, and still makes it easy to layer in extras on personal machines.
