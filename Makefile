home := home
flags := -v --restow --dotfiles
ignore := '\.md$$|\.gitignore$$'

# USER

.PHONY: user
user: home bin zsh i3 agents opencode claude pi
	@echo '-------------------- FINISHED ------------------------'
	@echo 'If you also want to install system configs run "make system"'
	@echo 'If you want to install packages run "make packages"'
	@echo 'If you want to install packages for work run "make packages-work"'

# INSTALLATION

.PHONY: packages
packages:
	./install-packages.sh

.PHONY: packages-work
packages-work:
	./install-packages.sh --work

.PHONY: home
home:
	stow $(flags) --ignore $(ignore) -t $$HOME $(home)

.PHONY: bin
bin:
	stow $(flags) --ignore $(ignore) -t $$HOME/.local/bin bin

# i3 needs all the custom binaries installed
.PHONY: i3
i3: bin
	stow $(flags) --ignore $(ignore) -t $$HOME/.config i3

.PHONY: zsh
zsh:
	stow $(flags) --ignore $(ignore) --ignore 'zshrc.luke|\.sh$$' -t $$HOME zsh
	./zsh/install-zsh.sh

# Shared guidelines and skills for all coding agents (AGENTS.md source of truth)
.PHONY: agents
agents:
	mkdir -p $$HOME/.agents
	stow $(flags) --dotfiles -t $$HOME agents

.PHONY: opencode
opencode:
	stow $(flags) --dotfiles -t $$HOME opencode

.PHONY: claude
claude:
	stow $(flags) --dotfiles -t $$HOME claude

.PHONY: pi
pi:
	mkdir -p $$HOME/.pi/agent
	stow $(flags) --dotfiles -t $$HOME pi
	# Taken from https://github.com/earendil-works/pi/tree/main/packages/coding-agent/examples/extensions/sandbox
	-cd pi/dot-pi/agent/extensions/sandbox && npm install

.PHONY: fonts
fonts:
	stow $(flags) --ignore $(ignore) -t $$HOME/.local/share/fonts fonts
	fc-cache -fv

# SYSTEM

theme :=  Everforest-Dark # MUST BE THE SAME AS IN gtk/settings.ini
icons := Papirus-Dark # MUST BE THE SAME AS IN gtk/settings.ini

.PHONY: system
system: gtk lightdm polkit sudoers udev claude-code
	@echo "--------------FINISHED--------------------"
	@echo "If you have a HDPI system checkout the README on how to fix the tiny screen."
	@echo "Also check out the INSTALL.md for more manual info (Secure Boot)."
	@echo "To install a grub theme please go to grub/README.md and install it manually."

.PHONY: gtk
gtk:
	sudo mkdir -p /usr/share/themes
	sudo cp -r ./home/dot-themes/* /usr/share/themes
	-sudo cp -i gtk/settings.ini /etc/gtk-3.0/
	gsettings set org.gnome.desktop.interface gtk-theme $(theme)
	gsettings set org.gnome.desktop.interface icon-theme $(icons)

.PHONY: lightdm
lightdm:
	-sudo cp -i lightdm/lightdm.conf lightdm/lightdm-gtk-greeter.conf /etc/lightdm/

.PHONY: polkit
polkit:
	sudo mkdir -p /etc/polkit-1/rules.d
	-sudo cp -i polkit/50-udiskie.rules /etc/polkit-1/rules.d/

.PHONY: sudoers
sudoers:
	-sudo cp -i sudoers.d/z_chrigi /etc/sudoers.d && sudo chmod 0440 /etc/sudoers.d/z_chrigi && sudo chown root:root /etc/sudoers.d/z_chrigi

.PHONY: udev
udev:
	sudo mkdir -p /etc/udev/rules.d
	-sudo cp -i ./udev/backlight.rules /etc/udev/rules.d/

.PHONY: claude-code
claude-code:
	sudo mkdir -p /etc/claude-code
	sudo cp ./claude/dot-claude/managed-settings.json /etc/claude-code/managed-settings.json

.PHONY: ollama-init
ollama-init:
	# Checkout https://docs.ollama.com/linux
	sudo useradd -r -s /bin/false -U -m -d /usr/share/ollama ollama
	sudo usermod -a -G ollama $(whoami)

.PHONY: ollama-config
ollama-config:
	sudo mkdir -p /etc/sv/ollama/log
	-sudo cp -i ./ollama/run /etc/sv/ollama/run
	-sudo cp -i ./ollama/log/run /etc/sv/ollama/log/run
	-sudo ln -s /etc/sv/ollama /var/service/

# HELP

.PHONY: help
help:
	@echo 'Usage: make [target]'
	@echo 'Targets:'
	@echo '  make [user]: install all the dotfiles (default)'
	@echo '  make pi: install the pi agent config + sandbox extension'
	@echo '  make packages: install all the packages'
	@echo '  make packages-work: install all the packages for work'
	@echo '  make system: install all the system configs'
	@echo '  make fonts: install the fonts'
	@echo '  make ollama-init: create the ollama user (see docs.ollama.com/linux)'
	@echo '  make ollama-config: install the ollama runit service'
	@echo '  make help: show this help message'
