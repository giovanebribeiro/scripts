#!/bin/sh

##
# Arquivo: vga.sh
# Autor: Giovane
# Responsavel pelo chaveamento entre os monitores externos o display do laptop
##

if ! xrandr | grep VGA-0 | grep disconnected >/dev/null ; then
	xrandr --output LVDS --mode 1600x900 --output VGA-0 --mode 1024x768 --above LVDS
else	
	xrandr --auto
fi