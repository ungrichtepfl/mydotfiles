# X11

On high DPI system, X11 has problems detecting the right screen dimensions.
Therefore everything seems tiny. To fix this change the dimensions in this xorg
config file (use `xrandr` for the identifier).

Checkout [the arch wiki](https://wiki.archlinux.org/title/HiDPI)
for more info.

Then symlink it:

```shell
sudo ln -s `pwd`/xorg.conf-hdpi /etc/X11/xorg.conf
```
