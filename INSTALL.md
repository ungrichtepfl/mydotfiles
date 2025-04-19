# Installation Guide

## Secure Boot

> [!Warning]
> Replacing the platform keys with your own can end up bricking hardware on some
> machines, including laptops, making it impossible to get into the firmware
> settings to rectify the situation. This is due to the fact that some device
> (e.g GPU) firmware (OpROMs), that get executed during boot, are signed using
> Microsoft 3rd Party UEFI CA certificate or vendor certificates. This is the
> case in many Lenovo Thinkpad X, P and T series laptops which uses the Lenovo
> CA certificate to sign UEFI applications and firmware.

If you use grub, reinstall it using (change `efi-directory` and target if needed):

```shell
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi \
                  --bootloader-id=GRUB --modules="tpm" --disable-shim-lock
```

Install sbctl, sbsigntool and efitools:

```shell
sudo xbps-install -S sbctl sbsigntool efitools
```

Secure boot must be disabled and all the SB keys must be deleted (can be done in
UEFI). To check if there are keys, use:

```shell
for var in PK KEK db dbx ; do efi-readvar -v $var ; done
```

If there are keys store them somewhere safe before you delete them:

```shell
for var in PK KEK db dbx ; do efi-readvar -v $var -o factory_${var}.esl ; done
```

Then follow the usage guide of `man sbctl`.

In a nutshell:

```shell
sudo sbctl create-keys
sbctl enroll-keys --microsoft
```

Then use `sudo sbctl verify` to find all the files efi files that you need to
sign also sign your current kernel (see in `boot/` for `vmlinuz-*` files).
However, if your kernel uses versioning omit the `--save` option):

```shell
sbctl sign --save <bootloader>
sbctl sign --save <kernel-file>
```

Check again `sudo sbctl status` and then reboot if everything is okay. `sbctl`
should have enable secure boot automatically.

You can use `sudo sbctl sign-all` to sign all files again after a system update.
Unfortunately, some Linux distros use versioned kernels so that the above
command will not work. However, you can use `sbsigntool` which configures a
kernel post install hook. Simply copy the file
`./sbsigntool/sbsigntool-kernel-hook` to `/etc/default/`.

Also, in .zshrc there is an update-all function defined which runs the above
command automatically.

Checkout the following links for more info:

- [Reddit/voidlinux - Guide Setting Up Secure Boot](https://www.reddit.com/r/voidlinux/comments/182m6k0/guide_setting_up_secure_boot/)
- [Arch Wiki - Secure Boot](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Implementing_Secure_Boot)
- [Arch Wiki - Secure Boot on Surface Pro 9](https://wiki.archlinux.org/title/Microsoft_Surface_Pro_9#Secure_Boot)
- [Arch Wiki - GRUB Secure Boot Support CA Keys](https://wiki.archlinux.org/title/GRUB#Secure_Boot_support)
