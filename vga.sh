#!/bin/sh

##
# Arquivo: vga.sh
# Licença: GPL
# Autor: Giovane
# Responsavel pelo chaveamento entre os monitores externos o display do laptop
##

# Quando o xrandr é executado junto com o cairo-compmgr dá problema. Por isso, o cairo deve ser eliminado antes da sobreposição e retomado depois.
teste=`ps axu | grep cairo-compmgr | grep -v grep`

if ! xrandr | grep VGA-0 | grep disconnected >/dev/null ; then	
	if [ "$teste" ] ; then
		killall cairo-compmgr
	fi

	xrandr --output LVDS --mode 1600x900 --output VGA-0 --mode 1024x768 --above LVDS --rate 75
else	
	xrandr --auto

	if [ ! "$teste" ] ; then
		cairo-compmgr &
	fi
fi
