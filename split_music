#!/bin/sh

##
# Arquivo: split_music.sh
# Autor: Giovane Boaviagem Ribeiro
# Objetivo: Cortar um arquivo de musica em faixas .wav com base no seu 
# arquivo .cue
# Dependências: cuetools, shntool
# Licença: GPL
##

# Comando: cuebreakpoints file.cue | shntool split file.flac

# Intervalo de atualização da barra (em segundos)
intervalo=1

# Porcentagem inicial da barra
perc=0

# Função que verifica se o processo está sendo executado.
running(){ ps $1 | grep $1 > /dev/null; }
# Função que mostra o tamanho do processso
sizeof(){ du -s "$1" | cut -f1; }

fileCue=$1
fileFlac=$2 

dialog \
--backtitle 'util' \
--yesno 'O processo não pode ser desfeito, nem interrompido. Deseja continuar?' \
0 0

[ $? -eq 1 ] && exit

cuebreakpoints $fileCue | shntool split $fileFlac | tail > out &


dialog --title "Executando separação..." --tailbox out
