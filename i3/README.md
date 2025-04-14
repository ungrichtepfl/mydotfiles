# i3

Download newest version from the [official website](https://i3wm.org/docs/repositories.html).

Set symlinks to setup:

```shell
ln -s `pwd`/i3 $HOME/.config/
ln -s `pwd`/i3blocks $HOME/.config/
ln -s `pwd`/i3status $HOME/.config/
ln -s `pwd`/i3status-rust $HOME/.config/
ln -s `pwd`/bin/* $HOME/.local/bin/
```

Fonts needed:

```shell
sudo apt install fonts-font-awesome
```

```shell
sudo xbps install font-awesome6 nerd-fonts
```

## Styling

You can use [](https://github.com/altdesktop/i3-style) to set a font. It will automatically
update your config.

```shell
cargo install i3-style
```

## Lockscreen

```shell
sudo xbps-install -S i3lock-color
```

## Network

You need network manager (especially important on void linux):

```shell
sudo xbps-install -S NetworkManager
```

Make sure the service is running.

Then install the gui tool `nm-applet`:

```shell
sudo xbps-install -S network-manager-applet-
```

## File Manager

Use thunar:

```shell
sudo xbps-install -S Thunar thunar-volman gvfs
```

With the last two packages you can enable automount of removable media in the
thunar settings.

## Flatpak

Use flatpak for whatsapp (whatsie) and Brave.

## Change sound

Use pactl with pulseaudio:

```shell
sudo xbps-install -S pulseaudio
```

## To enable screenshots

Install `maim` and xclip.

```shell
sudo apt install maim xclip
```

```shell
sudo xbps-install -S maim xclip
```

## Wallpaper

You need a wallpaper saved under `~/Pictures/Wallpapers/current.jpeg` and `feh`
needs to be installed.

```shell
sudo apt install feh
```

```shell
sudo xbps-install -S feh
```

## Finding files

Install faster find:

```shell
sudo apt install fd-find
```

```shell
sudo xbps-install -S fd
```

## Shadows and Transparency

```shell
sudo xbps-install -S picom
```

## i3status-rust (recommended)

```shell
sudo xbps-install -S i3status-rust
```

Enable in the bar block:

```text
status_command i3status-rust
```

## i3status

```shell
sudo xbps-install -S i3status
```

Enable in the bar block:

```text
status_command i3status
```

## i3blocks

```shell
sudo xbps-install -S i3blocks
```

Enable in the bar block:

```text
status_command i3blocks
```

You additionally need

```shell
sudo apt install lm-sensors pulsemixer
```

```shell
sudo xbps-install lm_sensors pulsemixer
```
