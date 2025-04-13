# Lightdm

```shell
sudo xbps-install -S lightdm lightdm-gtk3-greeter
```

**COPY** the files to `/etc/lightdm`. Do not symlink them, it will not work as
when lightdm starts the home directory is most probably not yet mounted.

Also, the background image that you want must be installed at `/usr/share/pixmaps/`
called `lightdm-background.jpeg`.
Also copy the theme and icons that you want to use to `/usr/share/themes/`, `/usr/share/icons/`
respectively.
Lightdm does not have access to your `~/.themes` folder.

You can test the setup using:

```shell
lightdm --test-mode --debug
```

If it doesn't work install:

```shell
sudo xbps-install -S xorg-server-xephyr
```

Somehow on void lightdm does not start `dbus` session. Especially, `flatpak`
does not really work without one. Install the .xprofile file to solve this.
