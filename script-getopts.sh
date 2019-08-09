#!/bin/bash
# script.sh
#
# Autor: Bruno Ricardo Rodrigues
# Ultima alteracao: 08/08/2019
#
# Mostra os logins e nomes de usuários do sistema
# Obs.: Le os dados do arquivo /etc/passwd
# 
# Versao 1: Mostra usuários e nomes separados por TAB
# Versao 2: Adicionado suporte a opcao -h
# Versao 3: Adicionado suporte a opcao -V e opcoes invalidas
# Versao 4: Arrumado bug quando nao tem opcoes, basename no nome do programa, -v extraindo direto dos cabecalhos, adicionadas opcoes --help e --version
# Versao 5: Adicionadas opcoes -s e --sort
# Versao 6: Adicionadas opcoes -r, --reverse, -u, --upercase, leitura de multiplas opcoes (loop)
# Versao 7: Melhorias no codigo para que fique mais legivel, adicionadas opcoes -d e --delimiter
#

ordenar=0
inverter=0
maiusculas=0
delimitador='\t'

MENSAGEM_USO="
Uso: $0 [OPÇÕES]

OPÇÕES:
-d C   Usa o caracter C como delimitador
-r     Inverte a listagem
-s     Ordena a listagem alfabeticamente
-u     Mostra a listagem em MAIÚSCULAS

-h     Mostra esta tela de ajuda e sai
-V     Mostra a versão do programa e sai
"

while getopts ":hVd:rsu" opcao; do
    case "$opcao" in
        s) ordenar=1 ;;
        r) inverter=1 ;;
        u) maiusculas=1 ;;
        d) delimitador=$OPTARG ;;
        h) echo "${MENSAGEM_USO}"
           exit 0
           ;;
        V) echo -n "$(basename "$0") -"
           grep '^# Versao ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#
           exit 0
           ;;
        \?) echo "Opção inválida: $OPTARG"
            exit 1
            ;;
        :) echo "Faltou argumento para: $OPTARG"
           exit 1
           ;;
    esac
done

lista=$(cut -d : -f 1,5 /etc/passwd)

test "$ordenar" = 1 && lista=$(echo "$lista" | sort)
test "$inverter" = 1 && lista=$(echo "$lista" | tac)
test "$maiusculas" = 1 && lista=$(echo "$lista" | tr a-z A-Z)

echo "$lista" | tr : "$delimitador"