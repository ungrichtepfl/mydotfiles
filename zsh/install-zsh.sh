#!/bin/bash

main(){

  if which zsh > /dev/null; then
    echo '"zsh" already installed.'
  else
    echo "Install zsh:"
    sudo apt install zsh -y
  fi
  
  # zshrc
  if [[ -f "${HOME}/.zshrc" ]]; then
    echo '".zshrc" already exists. Creating backup.'
    cp "${HOME}/.zshrc" "${HOME}/.zshrc.bak"
  fi

  echo 'Copy ".zshrc" to home folder:'
  cp .zshrc "${HOME}"
  
  # Change shell:
  zsh_str="zsh"
  if [[ ! $SHELL == *"$zsh_str"* ]]; then
    echo "Changing Shell. Please enter password."
    chsh -s `which zsh`
  fi
  
  # install plugins:
  
  ZSH_PLUGIN_PATH="${HOME}/.local/share/zsh/plugins"
  if [ -z "${ZSH_PLUGIN_PATH}" ]; then
    # TODO: try to export from .zshrc
    echo '"ZSH_PLUGIN_PATH" var is empty, should be exported in ".zshrc". Plugins will not be installed...'
  else
    echo "Installing plugins"
    install_plugins
  fi
  
}

install_plugins() {
  plug_path="${ZSH_PLUGIN_PATH}/zsh-syntax-highlighting"
  [[ -d "${plug_path}" ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${plug_path}"

  plug_path="${ZSH_PLUGIN_PATH}/zsh-history-substring-search"
  [[ -d "${plug_path}" ]] || git clone https://github.com/zsh-users/zsh-history-substring-search.git "${plug_path}"

  plug_path="${ZSH_PLUGIN_PATH}/zsh-autosuggestions"
  [[ -d "${plug_path}" ]] || git clone https://github.com/zsh-users/zsh-autosuggestions.git "${plug_path}"
}

main "$@"; zsh; exit
