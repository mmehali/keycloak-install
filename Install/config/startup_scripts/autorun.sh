#!/bin/bash -e

INSTALL_SRC=/opt/keycloak-install
KEYCLOAK_HOME=/opt/keycloak

STARTUP_SCRIPTS=${INSTALL_SRC}/config/startup-scripts
echo $STARTUP_SCRIPTS
if [[ -d "$STARTUP_SCRIPTS" ]]; then
  for f in "$STARTUP_SCRIPTS"/*; do
    echo "fichier :$f"
    if [[ "$f" == *.cli ]]; then
      echo " - executer le script cli : $f"
      ${KEYCLOAK_HOME}/bin/jboss-cli.sh --file="$f" 
    elif [[ -x "$f" -o "$f" !="autorun.sh" ]]; then
      echo " - executer le script: $f"
      "$f"
    else
      echo " - ignorer le script [fichier ni executable ni *.cli]: $STARTUP_SCRIPTS/$script"
    fi
  done
fi
