#!/bin/sh

##
# Arquivo: screenshot.sh
# Objetivo: Automatizar a operacao de printscreen em distros onde esta operacao nao eh suportada por default
# Autor: Giovane Boaviagem Ribeiro (Baseado no script de Edsandro Freitas)
# 
# Dependencia: imagemagick
# 
# Uso:
#	./screenshot.sh
#		Captura tela inteira e salva em $HOME.
#
#	./screenshot.sh -d ~/imagens
#		Captura tela inteira e salva em $HOME/imagens.
#
#	./screenshot.sh -r
#		Captura região/janela específica. Nesta opção o ponteiro do mouse vira uma cruz e com ela você pode selecionar a região ou clicar na janela que quer capturar.
#
#	./screenshot.sc -r -d ~/imagens
#		Captura região/janela específica e salva em $HOME/imagens. 	
##

# Diretorio padrao de armazenagem de imagens 
DIR=$HOME
VERSAO="1.0"
data_hora=$(date +"%d.%m.%y-%H.%M.%S")

# Flag que determina se a area a ser "fotografada" eh uma janela (valor 1) ou tela inteira (valor 0)
regiao=0

# Exibe a ajuda para o usuario
exibeAjuda(){
	echo " Uso: $(basename "$0") [OPÇÕES]"
	echo "		OPÇÕES:"
	echo "			-r			Screenshot de uma janela ou região específica"
	echo "							Se omitido, a imagem será da área de trabalho"
	echo "			-d <valor>	Local para salvar as screenshots (padrão '$HOME')"
	echo "							Exemplo: /home/usuario/imagens"
	echo "			-h, 		Mostra esta tela de ajuda e sai"
	echo "			-v, 		Mostra a versão do programa e sai"
	exit		
}	

mudaDiretorio(){	
	DIR="$1"
	# Se diretório não existir, crie !
	if [ ! -d "${DIR}" ]; 
		then mkdir "${DIR}"; 
	fi
}

takeScreenshot(){
	NOME="$DIR/screenshot-${data_hora}.png"
	if test "$regiao" = "1"
	then
		$(import "$NOME") # screenshot de tela especifica
	else
		$(import -window root "$NOME") # screenshot de tela inteira
	fi		
}

# O dois pontos depois do "d", significa que logo após o d, vem um valor. Este valor é armazenado na variavel OPTARG
while getopts "hvd:r" OPTION
do
	case $OPTION in
		h) exibeAjuda 
			;;
		v) echo $VERSAO
			exit				
			;;
		d) mudaDiretorio $OPTARG
			;;
		r) regiao=1
			;;
	 esac
done
shift $((OPTIND-1))	

takeScreenshot # tira o screenshot