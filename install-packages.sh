#!/bin/sh

DISTRO="$(lsb_release -i | cut -f 2-)"


if [ "$DISTRO" = "VoidLinux" ]; then
    echo "[install-packages] Installing packages on Void Linux"
    sudo xbps-install -Sy xorg polkit chrony dbus bluez setxkbmap \
        socklog-void man-pages man-pages-devel man-pages-posix \
        pulseaudio NetworkManager network-manager-applet blueman tlp linux-tools \
        binutils-devel lua-language-server \
        base-devel gdb curl wget git git-lfs jq zip unzip p7zip zstd zsh lz4 fzf \
        vim-huge neovim fastfetch cmake go zig cronie tzupdate \
        libsixel-devel chafa chafa-devel zoxide xcb-util-image-devel \
        libvips-devel tbb-devel libopencv-devel zenity htop \
        Thunar thunar-volman gvfs tumbler ffmpeg ffmpegthumbnailer \
        lm_sensors pulsemixer brightnessctl zramen dunst \
        maim xclip feh fd picom ripgrep eza bat dust \
        dua-cli autorandr yazi resvg poppler wiki-tui delta \
        i3 i3status-rust dmenu i3lock-color cups cups-filters \
        lightdm lightdm-gtk3-greeter elogind clang \
        flatpak xdg-desktop-portal-gtk gthumb mupdf ImageMagick \
        neomutt tmux mpv w3m-img notmuch pandoc urlscan \
        isync xdg-utils cyrus-sasl-xoauth2 goimapnotify mpv vlc inkscape \
        nerd-fonts font-awesome6 flameshot Solaar tealdeer
    if [ "$1" = "--work" ] || [ "$1" = "-w" ]; then
        sudo xbps-install -Sy evolution
    fi

    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install -y com.rtosta.zapzap com.brave.Browser org.telegram.desktop com.github.tchx84.Flatseal

    echo "[install-packages] Adding user to important groups."
    sudo usermod -aG wheel "$(whoami)"
    sudo usermod -aG storage "$(whoami)"
    sudo usermod -aG network "$(whoami)"
    sudo usermod -aG plugdev "$(whoami)"

    echo "[install-packages] Please check that the following services are enables in /var/service"
    echo "[install-packages]    polkitd"
    echo "[install-packages]    ntpd"
    echo "[install-packages]    tlp"
    echo "[install-packages]    dbus"
    echo "[install-packages]    NetworkManager"
    echo "[install-packages]    bluetoothd"
    echo "[install-packages]    lightdm"
    echo "[install-packages]    zramen"
    echo "[install-packages]    udevd"
    echo "[install-packages]    crond"
    echo "[install-packages]    sshd"
    echo "[install-packages]    elogind"
    echo "[install-packages]    nanoklogd"
    echo "[install-packages]    socklog-unix"
    echo "[install-packages]    cupsd"
    echo "[install-packages] Disable the following when you enable NetworkManager:"
    echo "[install-packages]    dhcpcd"
    echo "[install-packages]    wpa_supplicant"
    echo "[install-packages]    Also remove /etc/resolv.conf"
    echo "[install-packages] Disable the following when you enable elogind:"
    echo "[install-packages]    acpid"
    echo "[install-packages] Also install manually:"
    echo "[install-packages]    nvm (and then node)"
    echo "[install-packages]    rust"
    echo "[install-packages]    treesitter-cli"
else
    echo "[install-packages] Not yet implemented for $DISTRO. Nothing to install. Check manually if something does not work"
fi
