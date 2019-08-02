#!/bin/sh

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

declare -a default=(
	user@host
	/server/project/root/path/abs
	https://yourproject.url/
)