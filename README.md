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

## dbus

On `VoidLinux` the dbus is not launched automatically and my cause some problems
(e.g. with flatpak). It is therefore started in Xprofile.

## High DPI

On high dpi systems you need some additional config. Otherwise everything is tiny.

Checkout [the arch wiki](https://wiki.archlinux.org/title/HiDPI)
for more info.

Checkout [INSTALL.md](INSTALL.md) for more info on how to install and setup the distro.

## Zram

Instead of a swapfile you can use [Zram](https://wiki.archlinux.org/title/Zram).
For easy installation use [zramen](https://github.com/atweiden/zramen/blob/master/zramen)
on Void Linux. If you use zramen simply change the configuration in `/etc/sv/zramen/conf`
and activate the service `sudo ln -s /etc/sv/zramen /var/service`.

## Troubleshooting

### Void Linux

#### Update Repos

If you ever get this error trying to install a package or update the system:

```shell
$ sudo xbps-install -Suvy
[*] Updating repository `https://repo-fastly.voidlinux.org/current/x86_64-repodata' ...
ERROR: failed to read archive entry: index.plist: Truncated tar archive detected while reading data
ERROR: failed to open repository: https://repo-fastly.voidlinux.org/current: failed to read index: Invalid argument
```

You need to remove the corrupt index:

```shell
rm /var/db/xbps/https___repo-default_voidlinux_org_current/x86_64-repodata
```

Maybe you need to change the `https___` folder depending on which mirror you use.
