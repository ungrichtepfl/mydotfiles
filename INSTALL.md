# Installation Guide

## Additional repos

```shell
sudo xbps-install -Su void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
sudo xbps-install -S
```

## Nvidia

Checkout [install nvidia drivers](https://docs.voidlinux.org/config/graphical-session/graphics-drivers/nvidia.html)
in the void docs.

## Steam

It you will need `void-repo-nonfree`, `void-repo-multilib` and if you have a non-free driver installed `void-repo-multilib-nonfree`.

Then read `/usr/share/doc/steam/README.voidlinux`.

> [!NOTE]
> The 32bit versions of pulsaudio are `libpulseaudio-32bit` `alsa-plugins-pulseaudio-32bit`

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

## Surface Pro 4: touchscreen and pen

Touch and pen run through Intel Precise Touch & Stylus (IPTS). Its driver is
not in the mainline kernel, so it is built as a DKMS module from the
linux-surface patches. `iptsd` (userspace) turns the raw sensor data into
multitouch and pen events. No custom kernel is needed.

Without `iptsd` the kernel driver alone gives single-touch only, and no pen.

### Build tools and headers

Update and reboot first, so the headers match the running kernel:

```shell
sudo xbps-install -Su
sudo xbps-install -S dkms linux6.18-headers git meson ninja pkg-config cli11 eigen fmt-devel inih-devel spdlog
```

### Driver sources

The build files (`Makefile`, `dkms.conf`) come from `intel-precise-touch`, the
driver code from the linux-surface kernel patch. The driver code in
`intel-precise-touch` itself is old (last commit April 2024).

```shell
mkdir -p ~/Software/Surface-Kernel && cd ~/Software/Surface-Kernel
git clone --depth 1 https://github.com/linux-surface/intel-precise-touch
git clone --depth 1 --filter=blob:none --sparse https://github.com/linux-surface/linux-surface
git -C linux-surface sparse-checkout set patches/6.18
mkdir ipts-6.18 && cd ipts-6.18
git apply --include='drivers/hid/ipts/*' ../linux-surface/patches/6.18/0005-ipts.patch

sudo mkdir /usr/src/ipts-1.0.0
sudo cp ../intel-precise-touch/Makefile ../intel-precise-touch/dkms.conf /usr/src/ipts-1.0.0/
sudo cp -r drivers/hid/ipts /usr/src/ipts-1.0.0/src
```

### Report size fix

> [!Warning]
> Since kernel 6.18.55 (not in 6.18) the HID core rejects reports that are
> shorter than the HID descriptor says. The driver declares report 65 as
> 2 + 7485 bytes (7488 with the report ID) but sends only 7485 bytes. In
> multitouch mode every frame is dropped and touch stops as soon as `iptsd`
> runs. `dmesg` shows:
>
> `hid-generic 0000:1B96:0021.0003: Event data for report 65 was too short (7487 vs 7484)`
> `ipts ...: Failed to process buffer: -22`
>
> Not fixed in the linux-surface patches for 6.18 and 6.19 (checked
> 2026-10-16). Apply this again whenever the driver sources are replaced.

```shell
sudo sed -i 's/^#define IPTS_HID_REPORT_DATA_SIZE 7485$/#define IPTS_HID_REPORT_DATA_SIZE 7488/' /usr/src/ipts-1.0.0/src/desc.h
grep -n 'IPTS_HID_REPORT_DATA_SIZE' /usr/src/ipts-1.0.0/src/desc.h    # must show 7488
```

### DKMS

```shell
sudo dkms add -m ipts -v 1.0.0
sudo dkms build -m ipts -v 1.0.0
sudo dkms install -m ipts -v 1.0.0
dkms status
```

The module loads by itself at boot. The Void DKMS kernel hook rebuilds it on
every kernel update.

### IOMMU

The linux-surface kernel has a patch that turns off IOMMU translation for the
IPTS device. Without it IPTS gets DMAR errors. Without the patch, use a kernel
parameter instead. Edit `GRUB_CMDLINE_LINUX_DEFAULT` in `/etc/default/grub`
(the line must not start with `#`):

```shell
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="loglevel=4"$/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=4 intel_iommu=off"/' /etc/default/grub
grep -n '^GRUB_CMDLINE_LINUX_DEFAULT' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

`iommu=pt` might also work but is not tested.

### iptsd

Microsoft GSL is not packaged in Void, meson downloads it during setup. The
quotes around the `[]` options are needed in zsh.

```shell
cd ~/Software/Surface-Kernel
git clone --depth 1 https://github.com/linux-surface/iptsd
cd iptsd
meson setup build --prefix=/usr/local '-Dservice_manager=[]' -Ddebug_tools=calibrate,dump
ninja -C build
sudo meson install -C build
```

`iptsd` loads the preset for the digitizer (`surface-pro-4-b.conf` for
`1B96:0021`), then `/etc/iptsd.conf`, then `/etc/iptsd.d/*.conf`.

The built-in contact thresholds are too strict for the Surface Pro 4
([iptsd#171](https://github.com/linux-surface/iptsd/issues/171),
[iptsd#210](https://github.com/linux-surface/iptsd/issues/210)). The comments
in `/etc/iptsd.conf` still show the old values:

```shell
sudo tee /etc/iptsd.d/90-sp4-thresholds.conf >/dev/null <<'EOF'
[Contacts]
ActivationThreshold = 24
DeactivationThreshold = 20
OrientationThresholdMax = 5
EOF
```

### Calibration

Run with the service stopped. Touch with a fingertip (and flat finger) for some
seconds, then Ctrl+C. `Samples` must go up while touching.

```shell
dev=/dev/$(basename "$(dirname "$(dirname "$(grep -l 'HID_NAME=IPTS' /sys/class/hidraw/*/device/uevent)")")")
cd /tmp
sudo /usr/local/bin/iptsd-calibrate "$dev"
sudo cp iptsd_calib_1B96_0021_<time>_2mm.conf /etc/iptsd.d/91-calibration-1B96-0021.conf
```

If touches are missed, use the `10mm` file instead. The calibration depends on
the thresholds above, keep both files.

### runit service

```shell
sudo mkdir -p /etc/sv/iptsd/log
sudo tee /etc/sv/iptsd/run >/dev/null <<'EOF'
#!/bin/sh
exec 2>&1
for d in /dev/hidraw*; do
	if /usr/local/bin/iptsd-check-device --quiet --type=touchscreen "$d"; then
		exec /usr/local/bin/iptsd "$d"
	fi
done
echo "no IPTS touchscreen found"
sleep 10
exit 1
EOF
sudo chmod +x /etc/sv/iptsd/run
sudo ln -s /usr/bin/vlogger /etc/sv/iptsd/log/run
sudo ln -s /etc/sv/iptsd /var/service/
```

Logs: `sudo svlogtail daemon`. Stopping the service (`sudo sv down iptsd`)
switches the device back to single-touch without a reboot.

### Kernel updates

The DKMS hook does not stop a kernel update if the module fails to build. It
only prints `Building DKMS module: ipts-1.0.0... FAILED!` and the new kernel
boots without touch. Then:

- boot the old kernel from GRUB (it stays until `vkpurge`)
- `git -C ~/Software/Surface-Kernel/linux-surface pull` and take the driver
  sources from the matching `patches/<version>` folder
- remove the old module (`sudo dkms remove ipts/1.0.0 --all`,
  `sudo rm -r /usr/src/ipts-1.0.0`) and repeat the steps from "Driver sources",
  including the report size fix

To hold a kernel until the module builds again:
`sudo xbps-pkgdb -m hold linux6.18 linux6.18-headers`.

Checkout the following links for more info:

- [linux-surface - Supported Devices and Features](https://github.com/linux-surface/linux-surface/wiki/Supported-Devices-and-Features)
- [linux-surface - kernel patches](https://github.com/linux-surface/linux-surface/tree/master/patches)
- [linux-surface/intel-precise-touch](https://github.com/linux-surface/intel-precise-touch)
- [linux-surface/iptsd](https://github.com/linux-surface/iptsd)
