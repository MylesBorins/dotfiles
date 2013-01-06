#export path for homebrew
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:/usr/local/share/python:$PATH:."
export EDITOR="/usr/local/bin/mate -w"

#enables color for iTerm
export TERM=xterm-color

#Add UTF-8 Support
export LANG=en_US.UTF-8

export LC_CTYPE=en_US.UTF-8

#sets up proper alias commands when called
alias ls='ls -G'
alias ll='ls -hl'
alias flushcache='sudo killall -HUP mDNSResponder'
alias tunnel='ssh -D 8080 -f -C -q -N'
alias reverse-shell='ssh -f -C -q -N -R 12345:localhost:22'
alias androidDebug='adb forward tcp:9222 localabstract:chrome_devtools_remote'
alias matlab='/Applications/MATLAB_R2012a.app/bin/matlab -nodesktop'

# Git Tab Completion
source /usr/local/etc/bash_completion.d/git-completion.bash

# Homebrew autocomplete
source `brew --prefix`/Library/Contributions/brew_bash_completion.sh

#show branch in status line
#PS1='[\W$(__git_ps1 " (%s)")]\$ '
#export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'

# Setting GIT prompt
c_cyan=`tput setaf 6`
c_red=`tput setaf 1`
c_green=`tput setaf 2`
c_sgr0=`tput sgr0`

branch_color ()
{
    if git rev-parse --git-dir >/dev/null 2>&1
    then
        color=""
        if git diff --quiet 2>/dev/null >&2 
        then
            color=${c_green}
        else
            color=${c_red}
        fi
    else
        return 0
    fi
    echo -n $color
}

parse_git_branch ()
{
    if git rev-parse --git-dir >/dev/null 2>&1
    then
        gitver="["$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')"]"
    else
        return 0
    fi
echo -e $gitver
}

#It's important to escape colors with \[ to indicate the length is 0
PS1='[\W\[]${c_sgr0}\]\[\[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\]$ '
