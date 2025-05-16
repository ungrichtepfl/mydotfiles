# mydotfiles

All my Dotfiles at one place.

Install packages for specific distro with:

```shell
./install-packages.sh
```

Install user configs with
```shell
make
```

Install system configs with

```shell
make system
```


### dbus

On `VoidLinux` the dbus is not launched automatically and my cause some problems
(e.g. with flatpak). It is therefore started in Xprofile.

### High DPI

On high dpi systems you need some additional config. Otherwise everything is tiny.

Checkout [the arch wiki](https://wiki.archlinux.org/title/HiDPI)
for more info.

Checkout [INSTALL.md](INSTALL.md) for more info on how to install and setup the distro.

# Zram

Instead of a swapfile you can use [Zram](https://wiki.archlinux.org/title/Zram).
For easy installation use [zramen](https://github.com/atweiden/zramen/blob/master/zramen)
on VoidLinux. If you use zramen simply change the configuration in `/etc/sv/zramen/conf`
and activate the service `sudo ln -s /etc/sv/zramen /var/service`.
