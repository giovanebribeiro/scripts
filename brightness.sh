#!/bin/sh

##
# Arquivo: brightness.sh
# Autor: Giovane Boaviagem Ribeiro
# Objetivo: Alterar o brilho do monitor
##

op=$1

path_brightness=/sys/class/backlight/sony/brightness

v=$(cat $path_brightness)

case $op in
	-u) let v=$v+1;;
	-d) let v=$v-1;;
	*) echo "Opção inválida. Opções disponíveis: -u (up) ou -d (down)";;
esac

echo -n $v > $path_brightness
