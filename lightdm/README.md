# Lightdm

```shell
sudo xbps-install -S lightdm lightdm-gtk3-greeter
```

Symlink the config file to `/etc/lightdm` and check if the lightdm service is enabled.

Somehow on void lightdm does not start `dbus` session. Especially, `flatpak`
does not really work without one. Install the .xprofile file to solve this.
