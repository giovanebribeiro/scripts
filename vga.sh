#!/bin/bash

##
# Arquivo: vga.sh
# Licença: GPL
# Autor: Giovane
# Responsavel pelo chaveamento entre os monitores externos o display do laptop
##

IN=LVDS
EXT=VGA-0

if (xrandr | grep "$EXT" | grep "+")
	then
	xrandr --output $EXT --off --output $IN --auto
	else
		if (xrandr | grep "$EXT" | grep "connected")
			then
			xrandr --output $IN --off --output $EXT --auto
		fi
fi
