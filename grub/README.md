# GRUB

You can use [grub2-themes](https://github.com/vinceliuice/grub2-themes)
to generate new themes.

Copy the themes into `/boot/grub/themes/` and symlink the theme that you want to
`/boot/grub/themes/current`.

If you some icons are not displayed add the `--class` attribute after the menu
entry name. The class name must be the same name as the icon that you want
(in your theme's `icon` folder). E.g. `--class efi` if `efi.png` exists.
