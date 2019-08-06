#!/bin/sh

# SOBRE ESTE ARQUIVO
#
# este arquivo contem a lista de hosts possiveis de serem utilizados
# para o deploy de um projeto. a linha de comando para o deployer aceita
# que vc referencie um destes arrays para utilizar como credenciais na
# hora do upload - exemplo:
#
# sh deployer.sh {host_index}
#
# caso vc nao passe um host index, o index "default" será utilizado.
# caso passe, o deployer procurará pelo index nesta lista, e o retornará
# caso exista ou falhará caso nao existe. o index eh case sensitive.
#
# o padrao demonstrado no index default deve ser estritamente seguido.
# isso significa que apos declarar o array, a primeira linha deve ser
# a conexao ssh no padrao usuario@host. a segunda linha deve ser o path
# de destino dos arquivos no servidor, e a terceira linha a url do projeto
#
# DEPLOYMENT TYPE
#
# Deployment Type contem uma string com a estrategia que sera utilizada 
# no deploy. Recebe dois parametros:
#
# 1. rsync : utiliza rsync para syncar a pasta local com a remota
# 2. git   : utiliza git para syncar a pasta local com um --bare remoto

DEPLOYMENT_TYPE="rsync"

declare -a default=(
	user@server
	/project/path/on/server
	https://project.url/
)