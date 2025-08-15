home := home
flags := -v --restow --dotfiles
ignore := '\.md$$|\.gitignore$$'

# USER

.PHONY: user
user: home bin zsh i3
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

.PHONY: fonts
fonts:
	stow $(flags) --ignore $(ignore) -t $$HOME/.local/share/fonts fonts
	fc-cache -fv

# SYSTEM

theme :=  Everforest-Dark # MUST BE THE SAME AS IN gtk/settings.ini
icons := Papirus-Dark # MUST BE THE SAME AS IN gtk/settings.ini

.PHONY: system
system: gtk lightdm polkit sudoers udev
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


# HELP

.PHONY: help
help:
	@echo 'Usage: make [target]'
	@echo 'Targets:'
	@echo '  make [user]: install all the dotfiles'
	@echo '  make packages: install all the packages'
	@echo '  make system: install all the system configs'
	@echo '  make help: show this help message'
