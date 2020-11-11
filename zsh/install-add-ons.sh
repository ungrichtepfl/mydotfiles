#!/bin/sh

sudo apt install zsh-syntax-highlighting

cd /usr/share && git clone https://github.com/zsh-users/zsh-history-substring-search.git

cd /usr/share && git clone https://github.com/zsh-users/zsh-autosuggestions.git

echo "Changing Shell. Please enter password."

chsh -s `which zsh`
