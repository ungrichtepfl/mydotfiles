#!/bin/sh

if [ "$1" = "week" ];then 
  notify-send --urgency=critical "This Week" "<tt>$(gcalcli --nocolor --lineart ascii calw)</tt>"
else
  notify-send --urgency=critical "Today" "<tt>$(gcalcli --nocolor --lineart ascii agenda)</tt>"
fi
