#!/bin/bash

##
# Arquivo: cleaner.sh
# Autor: Giovane Boaviagem Ribeiro (Baseado no script de Renan Tomal Fernandes)
# Objetivo: Limpador de cache, logs, pacotes desnecessários e arquivos de backup
# Encoding: utf-8
##


# Verifica de qual distro pertence a distribuicao
#function distCheck(){
#
#}

. /etc/rc.conf
. /etc/rc.d/functions

function limpa_logs() {
    _logs_dir=/var/log
    log "Pasta de logs:" 1
    log "Antes:  $(du -sh "$_logs_dir")" 2

    find "$_logs_dir" |
        while read line; do
            if [ -f "$line" ]; then
                echo '' > "$line"
            fi
        done

    log "Depois: $(du -sh "$_logs_dir")" 2
    return 0
}

function limpa_pacotes_desnecessarios() {

    log "Pacotes desnecessários:" 1

    _packages=$(pacman -Qdtq)

    if [ -n "$_packages" ]; then
        (pacman -Rns $_packages && log "$(echo $_packages | wc -l) pacotes removidos($_packages)" 2) ||
        (log "Falha ao rodar o seguinte comando: pacman -Rns $_packages" 2 && return 1)
    else
        log "Nenhum pacote desnecessário encontrado" 2
    fi
    return 0
}

function limpa_cache_pacman(){

    log "Cache do pacman:" 1

    log "Antes:" 2 
    log "Tamanho: $(du -sh /var/cache/pacman/pkg/)" 3
    log "Número de arquivos: $(ls /var/cache/pacman/pkg | wc -l)" 3

    pacman -Sc --noconfirm >/dev/null 2>&1

    if [ $? != 0 ]; then
        log "Houve um erro ao executar: pacman -Sc --noconfirm" 2
        return 1
    fi

    log "Depois:" 2
    log "Tamanho: $(du -sh /var/cache/pacman/pkg/)" 3
    log "Número de arquivos: $(ls /var/cache/pacman/pkg | wc -l)" 3

    return 0

}

function limpa_yaourtbuild() {

    log "yaourt-build" 1

    if [ -d /var/abs/local/yaourtbuild/* ]; then
        log "Antes:  $(du -sh /var/abs/local/yaourtbuild/)" 2
        ls /var/abs/local/yaourtbuild/* |
            while read line; do
                if [ $INTERACTIVE == 1 ]; then
                    question "Apagar $line?"
                    if [ $question == 1 ]; then
                        rm -rf "$line"
                    fi
                else
                    rm -rf "$line"
                fi
            done
        log "Depois: $(du -sh /var/abs/local/yaourtbuild/)" 2
    else
        log "Nada encontrado" 2
    fi

    return 0
}

function limpa_yaourttmp(){

    log "yaourt-tmp" 1

    if [ -d /tmp/yaourt-tmp-* ]; then
        log "Antes:  $(du -sh /tmp)" 2
        rm -rf /tmp/yaourt-tmp-*
        log "Depois: $(du -sh /tmp)" 2
    else
        log "Nada encontrado" 2
    fi

    return 0

}

function limpa_backups(){
    log "Backups:" 1

    find / -iname "*~" -o -iname "*.bak" -o -iname "*.tmp" > /tmp/bkp_log
    count=0

    for i in $(seq 1 $(cat /tmp/bkp_log | wc -l )); do
        line=$(cat /tmp/bkp_log | head -n $i | tail -n 1)
        if [ $INTERACTIVE == 1 ]; then
            if [ -f "$line" ]; then
                question "Remover arquivo $line?"
            else
                question "Remover diretório $line?"
            fi

            if [ $question == 1 ]; then
                rm -rf "$line"
                count=$(expr $count + 1)
            fi
        else
            rm -rf "$line"
            count=$(expr $count + 1)
        fi
    done

    rm /tmp/bkp_log

    log "Arquivos removidos: $count" 2
    return 0
}

function add_bkp_file(){
    if [ ! -n "$arqs" ]; then
        arqs="$arqs\n"
    fi
    arqs="$arqs$1"
}

function pega_opcoes(){

    LIMPA_LOGS=1
    LIMPA_PACOTES=1
    LIMPA_CACHE=1
    LIMPA_YAOURTBUILD=1
    LIMPA_YAOURTTMP=1
    LIMPA_BACKUPS=0
    INTERACTIVE=0
    HELP=0
    VERSION=0.0.2

    until [ -f "$1" -o "$1" = "--" -o -z "$1" ]
    do
        case "$1" in
            --nologs | -l )
                LIMPA_LOGS=0
                ;;
            --nopackages | -p )
                LIMPA_PACOTES=0
                ;;
            --nocache | -c )
                LIMPA_CACHE=0
                ;;
            --noyaourtbuild | -b )
                LIMPA_YAOURTBUILD=0
                ;;
            --noyaourttmp | -t )
                LIMPA_YAOURTTMP=0
                ;;
            --clear-backups | -cb )
                LIMPA_BACKUPS=1
                ;;
            --interactive | -i )
                INTERACTIVE=1
                ;;
            --help | -h )
                usage
                exit 0
                ;;
            --version | -v )
                echo $VERSION
                exit 0
                ;;
            * )
                usage
                error "parâmetro desconhecido: $1" 1
                ;;
        esac
        shift
    done

}

function error(){
    echo -e "\e[1;31mERRO\e[0;31m: $1\e[m"
    exit $2
}

function log(){
    for((i=0;i<$2;i++)); do
        log="$log  "
    done
    log="$log $1\n"
}

function roda_comandos(){
    roda_funcao limpa_logs                   $LIMPA_LOGS        "Limpando logs"                                      "Limpar logs?"
    roda_funcao limpa_cache_pacman           $LIMPA_CACHE       "Limpando pacotes não instalados do cache do pacman" "Limpar pacotes não instalados do cache?"
    roda_funcao limpa_yaourtbuild            $LIMPA_YAOURTBUILD "Limpando yaourtbuild"                               "Limpar pasta de compilação do yaourt?"
    roda_funcao limpa_yaourttmp              $LIMPA_YAOURTTMP   "Limpando yaourt-tmp"                                "Limpar pasta temporária do yaourt?"
    roda_funcao limpa_pacotes_desnecessarios $LIMPA_PACOTES     "Removendo pacotes desnecessários"                   "Remover pacotes desnecessários(dependências inúteis)?"
    roda_funcao limpa_backups                $LIMPA_BACKUPS     "Limpando backups"                                   "Remover arquivos de backups?"
}

function roda_funcao(){
    if [ $2 == 1 ]; then

        if [ $INTERACTIVE == 1 ]; then
            question "$4"
            if [ $question == 0 ]; then
                return 1
            fi
        fi

        stat_busy "$3"
        $1
        if [ $? == 0 ]; then
            stat_done "$3"
        else
            stat_fail "$3"
        fi
    fi
}

function question(){
    printf "\e[1;33m?? \e[1;37m$1 \e[1;30m[\e[1;32mS\e[1;30m/\e[1;31mN\e[1;30m]:\e[m "
    read out

    case "$out" in
        's' | 'S' )
            resp=1
            ;;
        * )
            resp=0
            ;;
    esac

    if [ "x$2" == "xecho" ]; then
        echo $resp
    else
        question=$resp
    fi

    return 0
}

function usage(){
    echo "cleaner versão: $VERSION"
    echo "  Opções:"
    echo "    -h  | --help          : Mostra essa mensagem de ajuda e sai"
    echo "    -v  | --version       : Mostra a versão do programa e sai"
    echo "    -l  | --nologs        : Não esvazia os arquivos de log"
    echo "    -c  | --nocache       : Não limpa o cache do pacman"
    echo "    -p  | --nopackages    : Não remove os pacotes desnecessários(dependências que não são mais necessárias)"
    echo "    -b  | --noyaourtbuild : Não remove o conteudo de /var/abs/local/yaourtbuild"
    echo "    -t  | --noyaourttmp   : Não remove /tmp/yaourt-tmp-*"
    echo "    -cb | --clear-backups : Remove todos os *~ *.bak *.tmp de /"
    echo "    -i  | --interactive   : Modo interativo / não automático"
}

pega_opcoes $@

if [ "$(whoami)" != "root" ]; then

    _s=$(which sudo 2>/dev/null)
    echo "É necessário rodar esse script como root. usando o seguinte comando:"

    if [ -n "$_s" ]; then
        echo "sudo '$0' $@"
        sudo "$0" $@
    else
        echo "su -c '\"$0\" $@'"
        su -c "'$0' $@"
    fi
    exit 0
fi

log "Informações" 0

roda_comandos
echo -e "$log"

## Sugestões:
##        autor:
##        data:
##        conteúdo:
