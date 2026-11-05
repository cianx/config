# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_secrets ]; then
    . ~/.bash_secrets
fi

has_command() {
    command -v "$1" &> /dev/null
}

add_path() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        if [ -d $1 ] ; then
            export PATH="$1:$PATH"
        fi
    fi
}

# set PATH so it includes user's private bin if it exists
add_path "$HOME/bin"
add_path "$HOME/bin/local"
add_path "$HOME/.local/bin"
add_path "$HOME/go/bin"
add_path "/usr/local/go/bin"

if has_command nvim; then
	export EDITOR=nvim
	export VISUAL=nvim
fi

if has_command nvim; then
	export PAGER=less
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export GPG_TTY=$(tty)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

if [ -f "$HOME/.cargo/env" ]; then 
	. "$HOME/.cargo/env"
fi

###############################################################################
# Config
###############################################################################
bold=$(tput bold)
normal=$(tput sgr0)
reverse=$(tput rev)

#Color {code}    Color
#0   Black
#1   Red
#2   Green
#3   Yellow
#4   Blue
#5   Magenta
#6   Cyan
#7   White
magenta=$(tput setaf 5)

if has_command toilet; then
	toilet -f mono12 -F gay `hostname`
fi

echo "${bold}"`date`"${normal}"
if has_command fortune; then
	fortune
fi

if has_command keychain; then
	eval `keychain --eval --agents ssh ~/.ssh/id_rsa ~/.ssh/id_rsa.sterling`
fi
export TURBO_OPTS="--concurrency=4"
export JEST_OPTS="--maxWorkers=2 --no-coverage"

if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if has_command mcfly; then
	eval "$(mcfly init bash)"
fi

if has_command starship; then
	eval "$(starship init bash)"
fi

if has_command zoxide; then
	eval "$(zoxide init bash --cmd cd)"
	alias z='cd'
	alias zi='cdi'
fi


