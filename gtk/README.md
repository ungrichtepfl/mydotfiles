# GTK3 Themes

Additionally to copying the settings to `/etc/gtk-3.0` use the following
command to set the theme:

```shell
gsettings set org.gnome.desktop.interface gtk-theme Everforest-Dark
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
```

To find the themes:

```shell
ln -s `pwd`/themes $HOME/.themes
```
