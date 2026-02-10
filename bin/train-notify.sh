#!/bin/sh

if [ "$1" = "back" ];then
    notify-send --urgency=critical "Winti to Baden" "<tt>$(fahrplan from Winterthur to Baden)</tt>"
else
    notify-send --urgency=critical "Baden to Winti" "<tt>$(fahrplan from Baden to Winterthur)</tt>"
fi
