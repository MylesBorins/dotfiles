# Minimal legacy Bash config for systems where zsh isn't in play.
export BASH_SILENCE_DEPRECATION_WARNING=1

HOMEBREW_PREFIX="/opt/homebrew"

if [ -x "$HOMEBREW_PREFIX/bin/brew" ]; then
  eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
fi

[ -d "$HOMEBREW_PREFIX/opt/ccache/libexec" ] && export PATH="$HOMEBREW_PREFIX/opt/ccache/libexec:$PATH"

export EDITOR="code -w"
export VISUAL="$EDITOR"

export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell bash)"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash 2>/dev/null)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

alias ls='ls -G'
alias ll='ls -lah'
alias temp='cd "$TMPDIR"'

[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

PS1='[\W]$ '
