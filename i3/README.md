# i3

Download newest version from the [official website](https://i3wm.org/docs/repositories.html).

Set symlinks to setup:

```shell
ln -s `pwd`/i3 $HOME/.config/
ln -s `pwd`/i3blocks $HOME/.config/
ln -s `pwd`/i3status $HOME/.config/
ln -s `pwd`/bin/* $HOME/.local/bin/
```

Fonts needed:

```shell
sudo apt install fonts-font-awesome
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

## Finding files

Install faster find:

```shell
sudo apt install fd-find
```

## i3blocks

If i3blocks wants do be used install:

```shell
sudo apt install lm_sensors pulsemixer
```
