#!/bin/sh

# utilizo rsyn para fazer o deploy baseado nas configuracoes em ./deploy
# saiba mais lendo /deploy/README.md
#
# sh deploy.sh {host_index} {rsync_params}

deploy/_deploy.sh $1 $2