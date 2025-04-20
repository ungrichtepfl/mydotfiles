# GRUB

> [!Warning]
> FOLLOW THIS GUIDE STEP BY STEP.

Copy the themes into `/boot/grub/themes/` and symlink the theme that you want to
`/boot/grub/themes/current`.

You can use [grub2-themes](https://github.com/vinceliuice/grub2-themes)
to generate new themes or check online.

Then checkout `./grub` and modify on for your needs and then copy it to
`/etc/default/` (overwrite the existing one).

Then generate the new grub config:

```shell
sudo update-grub
```

Or if not existing:

```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

> [!Note]
> If some icons are not displayed add the `--class` attribute after the menu
> entry name. The class name must be the same name as the icon that you want
> (in your theme's `icon` folder). E.g. `--class efi` if `efi.png` exists.
