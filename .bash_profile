# Do not remind me I prefer bash yo
export BASH_SILENCE_DEPRECATION_WARNING=1

#export path for homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# export path for ccache
export PATH="/usr/local/opt/ccache/libexec:$PATH"

# export node modules
export PATH="$PATH:node_modules/.bin"

# export vscode as editor
export EDITOR="code -w"

#enables color for iTerm
export TERM=xterm-color

#Add UTF-8 Support
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# load fnm
eval "$(fnm env --use-on-cd)"

# give ls colors and make ll
alias ls='ls -G'
alias ll='ls -hl'

# open an ssh tunnel that you can pipe traffic too
# turn any box into a VPN!
alias tunnel='ssh -D 8080 -f -C -q -N'

# open a port on another box that you can
# pipe traffic from it back to you
alias reverse-shell='ssh -f -C -q -N -R 12345:localhost:22'

# afaik this flushes the dns cache on a mac
alias flushcache='sudo killall -HUP mDNSResponder'

# lazy
alias temp='cd $TMPDIR'

# osx has a built in ftp server :D
alias start-ftp='sudo -s launchctl load -w /System/Library/LaunchDaemons/ftp.plist'
alias stop-ftp='sudo -s launchctl unload -w /System/Library/LaunchDaemons/ftp.plist'

# for some really quick and dirty c work
alias compile='gcc -Wall -g -c'

# run tests from last PR
alias gt='tools/test.py -J `git show --name-only --pretty="" | grep 'test/'`'

# Source all bash completions installed by homebrew
# need to run the following command to support this
# brew install bash-completion

[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

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
PS1='[\W\[]${c_sgr0}\]\[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\]$ '
