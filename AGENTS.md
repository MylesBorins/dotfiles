# AGENTS.md

Notes for humans and coding agents working in this repo.

## Intent

- keep the repo small, readable, and personal
- favor straightforward shell scripts over heavy abstractions
- optimize primarily for Apple Silicon macOS

## Editing guidelines

- `.zshrc` is the primary shell config
- `.bash_profile` is a minimal legacy fallback; keep it small
- `.p10k.zsh` is generated; avoid hand-editing unless necessary
- `.tmux.conf` is the primary multiplexer config; keep it small and sensible, with `.screenrc` treated as legacy reference only
- shell integrations for `direnv`, `fzf`, `zoxide`, and `tmux` should stay lightweight and predictable
- keep setup changes conservative and re-runnable
- do not broaden symlinking without a clear reason

## Homebrew layout

- `Brewfile` is the shared base bundle
- `Brewfile.apps` contains generally wanted GUI apps that may be managed elsewhere, plus the JetBrains Mono Nerd Font
- `Brewfile.extras` contains optional fun/media/AI extras and extra apps such as Cursor

## Validation

After changes, prefer the smallest relevant checks:

- `bash -n .bash_profile`
- `bash -n setup.sh`
- `zsh -n .zshrc`
- `vim -Nu .vimrc -n -es +qall`
- `shellcheck setup.sh .bash_profile`

If `tmux` is installed locally, a quick parse check with `tmux -f .tmux.conf -L dotfiles start-server` is reasonable.

## Non-goals

- do not try to make this fully cross-platform in place
- do not replace the repo with a dotfile manager without discussion