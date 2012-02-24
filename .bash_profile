#export path for homebrew
export PATH="/usr/local/bin:$PATH:/usr/local/sbin"

#enables color for iTerm
export TERM=xterm-color

#Add UTF-8 Support
export LANG=en_US.UTF-8

export LC_CTYPE=en_US.UTF-8

#sets up proper alias commands when called
alias ls='ls -G'
alias ll='ls -hl'
alias octave='exec '/Applications/Octave.app/Contents/Resources/bin/octave''

# Git Tab Completion
source ~/git-completion.bash

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
