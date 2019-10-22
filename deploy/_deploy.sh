#!/usr/bin/env bash

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

# $1 = a name referencing an array on _hosts.sh
# $2 = rsync params if you wish to override defaults
# get the _hosts.sh array and split into separated Vars

_HOST_INDEX=${1:-'default'}

eval "CONN=\"\${$_HOST_INDEX[0]}\""
eval "DESTINATION=\"\${$_HOST_INDEX[1]}\""

# CONN is the connection string on _hosts. It will be splited
# into a ssh connection string and a port (if passed port)

CREDENTIALS=${CONN%:*}

if [[ $CONN == *":"* ]]; then
  PORT=${CONN##*:}
else
	PORT=22
fi

# will fail if the passed host reference ($1) wasnt found on _hosts.sh

if [ -z $CREDENTIALS ];then
	printf "\n${RED}ERROR: HOST NOT FOUND ON _HOSTS:${NC}\nHost '$_HOST_INDEX' cound not be found on _hosts.sh file\n\n"
	exit
fi

# get this script abs path and git branch name

BASEDIR=$( cd "$(dirname "$0")" ; pwd -P )
GITBRANCH=$(git branch | grep \* | cut -d ' ' -f2)

# cria a pasta de logs caso nao exista

mkdir -p $BASEDIR/log

# generates a data timestamp string

TODAY=`date '+%Y_%m_%d__%H_%M_%S'`;

# =================================================
# SHOWING THE REMINDER & INFO
# =================================================

printf "\n----------------------\n\n"
cat $BASEDIR/remind.txt
printf "\n\n----------------------\n\n"

printf "On branch: ${GREEN}$GITBRANCH${NC}\n"
printf "Deploying: ${GREEN}$_HOST_INDEX${NC}\n"
printf "Conneting: ${GREEN}$CREDENTIALS:$PORT${NC}\n"
printf "SendingTo: ${GREEN}$DESTINATION\n${NC}\n"

# =================================================
# DEPLOYING
# =================================================

RSYNC_PARAMS=${2:-'-vrzuh'}

# call rsync passing the directores, ignore list and ask to up using ssh

cd $BASEDIR/../ && rsync $RSYNC_PARAMS -e 'ssh -p '"$PORT" --files-from=$BASEDIR/directories.txt --exclude-from=$BASEDIR/ignore.txt . $CREDENTIALS:$DESTINATION | tee $BASEDIR/log/deploy_$TODAY.log

# =================================================
# LOG AND FINISH
# =================================================

# sign the log

echo "" >> $BASEDIR/log/deploy_$TODAY.log && 
echo "By: $(whoami)" >> $BASEDIR/log/deploy_$TODAY.log
date >> $BASEDIR/log/deploy_$TODAY.log
echo "Git Branch Deployed: $GITBRANCH" >> $BASEDIR/log/deploy_$TODAY.log

# finish message

printf "\nDone. Log file saved at log/deploy_$TODAY.log\n"