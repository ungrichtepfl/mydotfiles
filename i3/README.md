# i3

Symlink to config folders:

```shell
mkdir -p $HOME/.config/i3
mkdir -p $HOME/.config/i3status
ln -s `pwd`/i3.conf $HOME/.config/i3/config
ln -s `pwd`/i3status.conf $HOME/.config/i3status/config
```

## To enable screenshots

Install `maim`.

```shell
sudo apt install maim
```

## Wallpaper

You need a wallpaper saved under `~/Pictures/Wallpapers/current.jpeg` and `feh`
needs to be installed.

```shell
sudo apt install feh
```
