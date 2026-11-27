#!/bin/sh
# Set Xft.dpi for the active monitors. Programs started later use it for their
# font size.
#
# X has one DPI for all monitors. When the laptop panel is the only active
# monitor and it is high DPI, its real DPI is used. Otherwise (normal DPI panel,
# external monitors, or no physical size reported) 96 is used, which is the
# default of Xorg.
#
# The DPI is computed from the size of the monitor itself, not from the size
# of the X screen: the X screen can report 0x0 mm, and without Xft.dpi Xft
# computes the DPI from that size, which makes the fonts tiny.

if ! monitors="$(xrandr --query)"; then
    echo "set-xft-dpi: xrandr failed, Xft.dpi is not changed" >&2
    exit 1
fi

# A monitor line looks like:
# eDP-1 connected primary 2560x1440+5120+0 (normal left ...) 344mm x 194mm
# The diagonal is used so that a rotated monitor gives the same DPI.
# 13.3" 1080p panels have 166 DPI, high DPI panels from 15.6" 1440p (188) up.
high_dpi_threshold=175

dpi="$(printf '%s\n' "$monitors" | awk -v high_dpi_threshold="$high_dpi_threshold" '
    $2 == "connected" {
        geometry = ""
        for (i = 3; i <= NF; i++)
            if ($i ~ /^[0-9]+x[0-9]+\+[0-9]+\+[0-9]+$/) { geometry = $i; break }
        if (geometry == "") next  # connected, but switched off
        active++
        if ($1 ~ /^(eDP|LVDS|DSI)/) {
            laptop_panels++
            split(geometry, size, /[x+]/)
            diagonal_px = sqrt(size[1] ^ 2 + size[2] ^ 2)
            diagonal_mm = sqrt(($(NF - 2) + 0) ^ 2 + ($NF + 0) ^ 2)
        }
    }
    END {
        dpi = 96
        if (active == 1 && laptop_panels == 1 && diagonal_mm > 0) {
            panel_dpi = int(diagonal_px * 25.4 / diagonal_mm + 0.5)
            if (panel_dpi >= high_dpi_threshold) dpi = panel_dpi
        }
        print dpi
    }')"

echo "Xft.dpi: $dpi" | xrdb -merge
echo "set-xft-dpi: Xft.dpi set to $dpi"
