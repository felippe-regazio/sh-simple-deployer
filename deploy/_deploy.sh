
#!/bin/sh

source $(dirname "$0")/_hosts.sh

# for colored outputs
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

# =================================================
# COLLECTING PARAMS
# =================================================

# $1 = deve ser um nome para referenciar um array em _hosts, ou utilizara "default"
# $2 deve ser o set de parametros pra passar para o rsync

# pega o array contendo as credenciais do host desejado ou usa 'default'
# o eval utiliza o nome passado em HOST_INDEX pra referenciar um array em _hosts.sh
# The var CREDENTIALS must end with the ssh conn, and DESTINATION the server path

_HOST_INDEX=${1:-'default'}

eval "CONN=\"\${$_HOST_INDEX[0]}\""
eval "DESTINATION=\"\${$_HOST_INDEX[1]}\""

# CONN eh a primeira linha do array de conexao no arquivo _hosts
# ele representa a linha de conexao ssh no padrao user@server:port
# abaixo parseamos a conn e pegamos o que interessa
# credentials eh tudo que vem antes da porta, user@server por ex.
# DESTINATION eh a segunda linha no array em _hosts e deve ser o
# path absoluto para onde os arquivos serao enviados via rsync

CREDENTIALS=${CONN%:*}

# se o usuario configurou uma porta na string de conexao
# sabemos se ha uma porta caso exista o char : em $CONN

if [[ $CONN == *":"* ]]; then
  PORT=${CONN##*:}
else
	PORT=22
fi

# falha se o host nao foi encontrado em _hosts.sh

if [ -z $CREDENTIALS ];then
	echo "\nERROR: HOST NOT FOUND:\nHost '$_HOST_INDEX' cound not be found on _hosts.sh file\n"
	exit
fi

# define o diretorio abs em que o script esta

BASEDIR=$( cd "$(dirname "$0")" ; pwd -P )

# cria a pasta de logs caso nao exista

mkdir -p $BASEDIR/log

# pega a data de hoje em formato timestamp

TODAY=`date '+%Y_%m_%d__%H_%M_%S'`;

# =================================================
# SHOWING THE REMINDER
# =================================================

echo "\n----------------------\n"
cat $BASEDIR/remind.txt
echo "\n\n----------------------\n"

echo "On branch: ${GREEN}$(git branch | grep \* | cut -d ' ' -f2)${NC}"
echo "Deploying: ${GREEN}$_HOST_INDEX${NC}"
echo "Conneting: ${GREEN}$CREDENTIALS:$PORT${NC}"
echo "SendingTo: ${GREEN}$DESTINATION\n${NC}"

# =================================================
# DEPLOYING
# =================================================

RSYNC_PARAMS=${2:-'-vrzuh'}

# chama o rsync passando a lista de arquivos e a lista de excludes como
# parametro para upload dos arquivos via ssh seguindo os params passados
# um log do output desse comando será salvo na pasta ./log 

cd $BASEDIR/../ && rsync $RSYNC_PARAMS -e 'ssh -p '"$PORT" --files-from=$BASEDIR/directories.txt --exclude-from=$BASEDIR/ignore.txt . $CREDENTIALS:$DESTINATION | tee $BASEDIR/log/deploy_$TODAY.log

# =================================================
# LOG AND FINISH
# =================================================

# assina o log com o nome do user atual

echo "" >> $BASEDIR/log/deploy_$TODAY.log && 
echo "By: $(whoami)" >> $BASEDIR/log/deploy_$TODAY.log
date >> $BASEDIR/log/deploy_$TODAY.log
echo "Git Branch Deployed: $(git branch | grep \* | cut -d ' ' -f2)" >> $BASEDIR/log/deploy_$TODAY.log

# finish message

echo "\nDone. Log file saved at log/deploy_$TODAY.log"