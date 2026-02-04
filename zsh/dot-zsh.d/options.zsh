# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

## Options section
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expansion with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd		                                                # Automatically cd into typed directory.

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' menu select

# Load run-help correctly
unalias run-help 2>/dev/null
autoload -U run-help

# Enable autocomplete
autoload -Uz compinit
zmodload zsh/complist
compinit -C # Enable caching
_comp_options+=(globdots)		# Include hidden files.

# Theming section
autoload -U colors zcalc
colors

# For external auto completion:
export ZFUNC_PATH="$HOME/.zfunc"
fpath+="$ZFUNC_PATH"

# Use nvim as default editor
if (( $+commands[nvim] )); then
    export EDITOR=$(which nvim)
    export VISUAL=$(which nvim)
elif (( $+commands[vim] )); then
    export EDITOR=$(which vim)
    export VISUAL=$(which vim)
else
    export EDITOR=$(which vi)
    export VISUAL=$(which vi)
fi

