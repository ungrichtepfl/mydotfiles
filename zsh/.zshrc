## Options section
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
HISTFILE=~/.zhistory
HISTSIZE=2000
SAVEHIST=10000
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word


## Keybindings section
bindkey -e
bindkey '^[[7~' beginning-of-line                               # Home key
bindkey '^[[H' beginning-of-line                                # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
    bindkey "${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                                     # End key
bindkey '^[[F' end-of-line                                     # End key
if [[ "${terminfo[kend]}" != "" ]]; then
    bindkey "${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                                  # Insert key
bindkey '^[[3~' delete-char                                     # Delete key
bindkey '^[[C'  forward-char                                    # Right key
bindkey '^[[D'  backward-char                                   # Left key
bindkey '^[[5~' history-beginning-search-backward               # Page up key
bindkey '^[[6~' history-beginning-search-forward                # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                                     #
bindkey '^[Od' backward-word                                    #
bindkey '^[[1;5D' backward-word                                 #
bindkey '^[[1;5C' forward-word                                  #
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action

## Alias section
alias cp="cp -i"                                                # Confirm before overwriting something
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias gitac='git add . && git commit'				# git add and commit concatenated
alias gitu='git add . && git commit && git push'
alias ls='ls --color'						# Show content of folder colorized
alias nmutt='neomutt'
alias vim='nvim'
alias saptu='sudo apt update'					# Update all packages
alias saptuu='sudo apt update && sudo apt upgrade -y' 		# Update and upgrade all packages
alias saptufu='sudo apt update && sudo apt full-upgrade -y'	# Update and upgrade all packages
alias saptufup='sudo apt update && sudo apt full-upgrade -y; update-zsh-plugins'	# Update and upgrade all packages, plus zsh plugins
alias sapti='sudo apt install'
# kitty terminal ssh
alias sshk="kitty +kitten ssh"
alias ranger=". ranger" # such that when quitting the terminal is already in the directory
alias ra="ranger"
# Python
alias pd="pydoc3"
# Git
alias cdg='cd $(git rev-parse --show-toplevel)'/ca
alias gita='git add'
alias gitb='git --no-pager branch'
alias gitc='git checkout'
alias gitca='git commit --amend'
alias gitcan='git commit --amend --no-edit'
alias gitcp='git cherry-pick'
alias gits='git status --short'
alias gitd='git diff'
alias gitl='git lg'
alias gitcb='git checkout -b'
alias gitcm='git commit --signoff'
alias gitcmm='git commit --signoff -m'
alias gitds='gitd --staged'
alias gitpo='git pull origin'
alias gitpom='gitpo master'
alias gitpomr='gitpom --rebase'
alias gitpod='gitpo develop'
alias gitpodr='gitpod --rebase'
gitpsu() {
    local _git_branch="$(git branch --show-current)"
    git push --set-upstream origin $_git_branch
}

ssource(){
    [ -f "${1}" ] && source "${1}"
}

# Theming section
autoload -U compinit colors zcalc
compinit -d
colors

# enable substitution for prompt
setopt prompt_subst

# Prompt (on left side) similar to default bash prompt, or redhat zsh prompt with colors
#PROMPT="%(!.%{$fg[red]%}[%n@%m %1~]%{$reset_color%}# .%{$fg[green]%}[%n@%m %1~]%{$reset_color%}$ "
# Maia prompt
#PROMPT="%B%{$fg[cyan]%}%(4~|%-1~/.../%2~|%~)%u%b >%{$fg[cyan]%}>%B%(?.%{$fg[cyan]%}.%{$fg[red]%})>%{$reset_color%}%b " # Print some system information when the shell is first started
# Self-made PROMPT
PROMPT=$'%{$fg_bold[red]%}%n%{$fg_bold[yellow]%}@%{$fg_bold[green]%}%m %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%}%{$fg[blue]%}%{$fg_bold[blue]%} %#%{$reset_color%} '

# Print a greeting message when shell is started
#echo $USER@$HOST  $(uname -srm) $(lsb_release -rcs)
## Prompt on right side:
#  - shows status of git when in git repository (code adapted from https://techanic.net/2012/12/30/my_git_prompt_for_zsh.html)
#  - shows exit status of previous command (if previous command finished with an error)
#  - is invisible, if neither is the case

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"                              # plus/minus     - clean repo
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"             # A"NUM"         - ahead by "NUM" commits
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"           # B"NUM"         - behind by "NUM" commits
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"     # lightning bolt - merge conflict
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"       # red circle     - untracked files
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"     # yellow circle  - tracked files modified
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"        # green circle   - staged changes present = ready for "git push"

parse_git_branch() {
    # Show Git branch/tag, or name-rev if on detached head
    ( git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD ) 2> /dev/null
}

parse_git_state() {
    # Show different symbols as appropriate for various Git repository states
    # Compose this value via multiple conditional appends.
    local GIT_STATE=""
    local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_AHEAD" -gt 0 ]; then
        GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
    fi
    local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_BEHIND" -gt 0 ]; then
        GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
    fi
    local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
    if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
    fi
    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
    fi
    if ! git diff --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
    fi
    if ! git diff --cached --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
    fi
    if [[ -n $GIT_STATE ]]; then
        echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
    fi
}

git_prompt_string() {
    local git_where="$(parse_git_branch)"

    # If inside a Git repository, print its branch and state
    [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"

    # If not inside the Git repo, print exit codes of last command (only if it failed)
    [ ! -n "$git_where" ] && echo "%{$fg[red]%} %(?..[%?])"
}

# Right prompt with exit status of previous command if not successful
#RPROMPT="%{$fg[red]%} %(?..[%?])"
# Right prompt with exit status of previous command marked with ✓ or ✗
RPROMPT="%(?.%{$fg[green]%}✓ %{$reset_color%}.%{$fg[red]%}✗ %{$reset_color%})"


# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r


## Plugins section: Enable fish style features
export ZSH_PLUGIN_PATH="${HOME}/.local/share/zsh/plugins"
# Use syntax highlighting
# ssource "${ZSH_PLUGIN_PATH}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
ssource "${ZSH_PLUGIN_PATH}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
# Use history substring search
ssource "${ZSH_PLUGIN_PATH}/zsh-history-substring-search/zsh-history-substring-search.zsh"
# More suggsetions
fpath+="${ZSH_PLUGIN_PATH}/zsh-completions/src"

# bind UP and DOWN arrow keys to history substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Apply different settigns for different terminals
case $(basename "$(cat "/proc/$PPID/comm")") in
    login)
        RPROMPT="%{$fg[red]%} %(?..[%?])"
        alias x='startx ~/.xinitrc'      # Type name of desired desktop after x, xinitrc is configured for it
        ;;
        #  'tmux: server')
        #        RPROMPT='$(git_prompt_string)'
        #		## Base16 Shell color themes.
        #		#possible themes: 3024, apathy, ashes, atelierdune, atelierforest, atelierhearth,
        #		#atelierseaside, bespin, brewer, chalk, codeschool, colors, default, eighties,
        #		#embers, flat, google, grayscale, greenscreen, harmonic16, isotope, londontube,
        #		#marrakesh, mocha, monokai, ocean, paraiso, pop (dark only), railscasts, shapesifter,
        #		#solarized, summerfruit, tomorrow, twilight
        #		#theme="eighties"
        #		#Possible variants: dark and light
        #		#shade="dark"
        #		#BASE16_SHELL="/usr/share/zsh/scripts/base16-shell/base16-$theme.$shade.sh"
        #		#[[ -s $BASE16_SHELL ]] && ssource $BASE16_SHELL
        #		# Use autosuggestion
        #		ssource /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
        #		ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
        #  		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
        #     ;;
    *)
        RPROMPT='$(git_prompt_string)'
        # Use autosuggestion
        ssource "${ZSH_PLUGIN_PATH}/zsh-autosuggestions/zsh-autosuggestions.zsh"
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
        ;;
esac


# Add path to path
export PATH=$PATH:$HOME/.local/bin
export PATH=/usr/local/MATLAB/R2021b/bin:$PATH
export PATH=$HOME/cmake-install/bin:$PATH
export PATH="$HOME/.poetry/bin:$PATH"

# Config
export XDG_CONFIG_HOME="$HOME/.config"
# For external auto completion:
fpath+=$HOME/.zfunc

# Golang:
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/.local/go
export PATH=$PATH:$HOME/.local/go/bin

# Ros
ssource "/opt/ros/noetic/setup.zsh"

# Haskell:
ssource "$HOME/.ghcup/env" # ghcup-env

# Nvm:
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Cargo
# load cargo
if [ ! -e ~/.zfunc/_rustup -a $commands[rustup] ]; then
    mkdir -p ~/.zfunc
    rustup completions zsh > ~/.zfunc/_rustup
fi

# Get no sync data:
ssource $HOME/.zshrc.nosync
