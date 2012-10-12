#!/bin/sh

##
# Arquivo: brightness.sh
# Autor: Giovane Boaviagem Ribeiro
# Objetivo: Alterar o brilho do monitor
# Uso: brightness.sh [opções]
# -u 	Aumenta o brilho do monitor
# -d	Reduz o brilho do monitor
# -i 	Seta as configurações iniciais do script
##

# Adicione aqui as pastas que podem variar
folders=("acpi_video0" "sony")

op=$1
path_backlight="/sys/class/backlight"
i=0

while [ $i != ${#folders[@]} ]
do
	if [ -e $path_backlight/${folders[$i]} ]
	then
		pasta=${folders[$i]}
	fi

	let i=$i+1
done

v=$(cat $path_backlight/$pasta/brightness)

case $op in
	-u) let v=$v+1;;
	-d) let v=$v-1;;
	-i) let v=5 ; chmod 666 $path_backlight/$pasta/brightness ; sleep 1 ;;
	*) echo "Opção inválida. Opções disponíveis: -u (up), -d (down) ou -i (inicializa as permissões do arquivo e seta o valor inicial para 5)";;
esac

echo -n $v > $path_backlight/$pasta/brightness
