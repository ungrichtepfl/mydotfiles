#!/bin/sh

DISTRO="$(lsb_release -i | cut -f 2-)"

if [ "$DISTRO" = "VoidLinux" ]; then
  echo "[install-packages] Installing packages on Void Linux"
  sudo xbps-install -Sy polkit chrony dbus \
      pulseaudio NetworkManager network-manager-applet \
      base-devel curl wget git git-lfs zsh \
      vim neovim neofetch cmake go zig \
      Thunar thunar-volman gvfs lm_sensors pulsemixer \
      brightnessctl maim xclip feh fd picom ripgrep \
      i3 i3status-rust dmenu i3lock-color \
      lightdm lightdm-gtk3-greeter \
      flatpak evolution gthumb mupdf \
      neomutt khard w3m vlc inkscape \
      nerd-fonts font-awesome6

  flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  flatpak install -y com.rtosta.zapzap com.brave.Browser org.telegram.desktop

  echo "[install-packages] Adding user to important groups."
  sudo usermod -aG wheel "$(whoami)"
  sudo usermod -aG storage "$(whoami)"
  sudo usermod -aG network "$(whoami)"

  echo "[install-packages] Please check that the following services are enables in /var/service"
  echo "[install-packages]    polkitd"
  echo "[install-packages]    chronyd"
  echo "[install-packages]    dbus"
  echo "[install-packages]    NetworkManager"
else
  echo "[install-packages] Not yet implemented for $DISTRO. Nothing to install. Check manually if something does not work"
fi
