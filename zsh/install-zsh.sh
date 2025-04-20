#!/bin/bash

set -e

main(){

    DISTRO="$(lsb_release -i | cut -f 2-)"

    if which zsh > /dev/null; then
        echo '"zsh" already installed.'
    else
        echo "Install zsh:"
        if [[ $DISTRO == "VoidLinux" ]]; then
                sudo xbps-install -S zsh -y
            else
                echo "Assuming Debian based system."
            sudo apt install zsh -y
        fi
    fi

    # Change shell:
    zsh_str="zsh"
    if [[ ! $SHELL == *"$zsh_str"* ]]; then
        echo "Changing Shell. Please enter password."
        chsh -s "$(which zsh)"
    fi

    # install plugins:

    ZSH_PLUGIN_PATH="${HOME}/.local/share/zsh/plugins"
    if [ "$ZSH_PLUGIN_PATH" = "" ]; then
        # TODO: try to export from .zshrc
        echo '"ZSH_PLUGIN_PATH" var is empty, should be exported in ".zshrc". Plugins will not be installed...'
    else
        echo "Installing plugins"
        install_plugins
    fi
}

install_plugins() {
    plug_path="${ZSH_PLUGIN_PATH}/zsh-syntax-highlighting"
    [[ -d "$plug_path" ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plug_path"

    plug_path="${ZSH_PLUGIN_PATH}/zsh-history-substring-search"
    [[ -d "$plug_path" ]] || git clone https://github.com/zsh-users/zsh-history-substring-search.git "$plug_path"

    plug_path="${ZSH_PLUGIN_PATH}/zsh-autosuggestions"
    [[ -d "$plug_path" ]] || git clone https://github.com/zsh-users/zsh-autosuggestions.git "$plug_path"

    plug_path="${ZSH_PLUGIN_PATH}/fast-syntax-highlighting"
    [[ -d "$plug_path" ]] || git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$plug_path"

    plug_path="${ZSH_PLUGIN_PATH}/zsh-completions"
    [[ -d "$plug_path" ]] || git clone https://github.com/zsh-users/zsh-completions.git "$plug_path"

    plug_path="${ZSH_PLUGIN_PATH}/zsh-z"
    [[ -d "$plug_path" ]] || git clone https://github.com/agkozak/zsh-z.git "$plug_path"
}

main "$@";
