## Alias section
alias cp="cp -i"                                                # Confirm before overwriting something
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias gitac='git add . && git commit'				# git add and commit concatenated
alias gitu='git add . && git commit && git push'

if (( $+commands[eza] )); then
    alias ls='eza --color=auto'                                 # Show content of folder colorized
    alias ll='eza -lh'                                          # Show content of folder in list format
    alias la='eza -a'                                           # Show all content of folder
    alias lla='eza -lha'                                        # Show all content of folder in list format
else
    alias ls='ls --color'                                       # Show content of folder colorized
    alias ll='ls -lh'                                           # Show content of folder in list format
    alias la='ls -a'                                            # Show all content of folder
    alias lla='ls -lha'                                         # Show all content of folder in list format
fi
if (( $+commands[bat] )); then
    alias cat="bat"
fi
if (( $+commands[dust] )); then
    alias du="dust"
fi
if (( $+commands[dua] )); then
    alias ncdu="dua i"
fi

if [ "$TERM" = "kitty" ]; then
    # kitty terminal ssh
    alias ssh='kitty +kitten ssh'
elif [ "$TERM" = "alacritty" ]; then
    # alacritty terminal ssh
    alias ssh='TERM="xterm-256color" ssh'
fi

# Create as alias for nuget
alias nuget="mono /usr/local/bin/nuget.exe"

# Handy
alias edit-video="avidemux"

function web-arch(){
    w3m "https://wiki.archlinux.org/index.php?search=$1"
}

function web-wiki(){
    # All but first arguments passed as string
    wiki-tui "${@:2}"
}

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
alias gitfprl="git fetch -p ; git branch -r | awk '{print \$1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print \$1}' | xargs git branch -D"

# Distro specific config

DISTRO="$(lsb_release -i | cut -f 2-)"

if [[ "$DISTRO" == "VoidLinux" ]]; then
    alias poweroff='sudo poweroff'
    alias reboot='sudo reboot'
    alias shutdown='sudo shutdown'
    vupdate-all() {
        echo "[update-all] Updating system..."
        sudo xbps-install -Suy xbps
        sudo xbps-install -Suy
        if command -v sbctl 2>&1 >/dev/null; then
            echo "[update-all] Resigning efi files if needed..."
            sudo sbctl sign-all
        fi
        echo "[update-all] Update zsh-plugins..."
        update-zsh-plugins
        echo "[update-all] Update flatpak..."
        flatpak update -y
    }
else
    # Assume Debian like system
    alias saptu='sudo apt update'					# Update all packages
    alias saptuu='sudo apt update && sudo apt upgrade -y' 		# Update and upgrade all packages
    alias saptufu='sudo apt update && sudo apt full-upgrade -y'	# Update and upgrade all packages
    alias saptufup='sudo apt update && sudo apt full-upgrade -y; update-zsh-plugins'	# Update and upgrade all packages, plus zsh plugins
    alias sapti='sudo apt install'
fi

