#!/bin/sh

source $(dirname "$0")/_hosts.sh

# $1 = deve ser um nome para referenciar um array em _hosts, ou utilizara "default"
# $2 deve ser o set de parametros pra passar para o rsync

# ------------------------------------------------------------------------------------

# pega o array contendo as credenciais do host desejado ou usa 'default'
# o eval utiliza o nome passado em HOST_INDEX pra referenciar um array em _hosts.sh
# The var CREDENTIALS must end with the ssh conn, and DESTINATION the server path

_HOST_INDEX=${1:-'default'}

eval "CREDENTIALS=\"\${$_HOST_INDEX[0]}\""
eval "DESTINATION=\"\${$_HOST_INDEX[1]}\""

# falha se o host nao foi encontrado em _hosts.sh

if [ -z $CREDENTIALS ];then
	echo "\nERROR: HOST NOT FOUND:\nHost '$_HOST_INDEX' cound not be found on _hosts.sh file\n"
	exit
fi

# pega os parametros rsync para o deploy ou usa um default

RSYNC_PARAMS=${2:-'-vrzch'}

# ------------------------------------------------------------------------------------

# define o diretorio abs em que o script esta

BASEDIR=$( cd "$(dirname "$0")" ; pwd -P )

# cria a pasta de logs caso nao exista

mkdir -p $BASEDIR/log

# pega a data de hoje em formato timestamp

TODAY=`date '+%d_%m_%Y__%H_%M_%S'`;

# ------------------------------------------------------------------------------------

echo "\n----------------------\n"
cat $BASEDIR/remind.txt
echo "\n\n----------------------\n\n"

# chama o rsync passando a lista de arquivos e a lista de excludes como
# parametro para upload dos arquivos via ssh seguindo os params passados
# um log do output desse comando será salvo na pasta ./log 

cd $BASEDIR/../ && rsync $RSYNC_PARAMS -e ssh --files-from=$BASEDIR/directories.txt --exclude-from=$BASEDIR/ignore.txt . $CREDENTIALS:$DESTINATION | tee $BASEDIR/log/deploy_$TODAY.log

# assina o log com o nome do user atual

echo "" >> $BASEDIR/log/deploy_$TODAY.log && date >> $BASEDIR/log/deploy_$TODAY.log && whoami >> $BASEDIR/log/deploy_$TODAY.log

# finish message

echo "\nDone. Log file saved at log/deploy_$TODAY.log"