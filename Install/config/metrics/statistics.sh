#!/bin/bash

INSTALL_SRC=/vagrant/Install
# "all" pour activer les 3.
KEYCLOAK_STATISTICS=db,http,jgroups

if [ -n "$KEYCLOAK_STATISTICS" ]; then
   IFS=',' read -ra metrics <<< "$KEYCLOAK_STATISTICS"
   for file in ${INSTALL_SRC}/config/metrics/*.cli; do
      name=${file##*/}
      base=${name%.cli}
      if [[  $KEYCLOAK_STATISTICS == *"$base"* ]] || [[  $KEYCLOAK_STATISTICS == *"all"* ]];  then
         sudo /opt/keycloak/bin/jboss-cli.sh --file="$file"  --properties=env.properties >& /dev/null
      fi
   done
fi
