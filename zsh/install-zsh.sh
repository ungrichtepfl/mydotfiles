#!/bin/sh

sudo apt install zsh -y

cp .zshrc ~

sudo apt install zsh-syntax-highlighting -y

cd /usr/share && git clone https://github.com/zsh-users/zsh-history-substring-search.git

cd /usr/share && git clone https://github.com/zsh-users/zsh-autosuggestions.git

echo "Changing Shell. Please enter password."

chsh -s `which zsh`
