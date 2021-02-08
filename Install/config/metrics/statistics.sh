#!/bin/bash

INSTALL_SRC=/opt/keycloak-install
KEYCLOAK_HOME=/opt/keycloak
 
echo "-----------------------------------------------------------"
echo " - configration des metriques http                         "
echo "-----------------------------------------------------------"
sudo ${KEYCLOAK_HOME}/bin/jboss-cli.sh --file=${INSTALL_SRC}/config/metrics/http.cli 

echo "-----------------------------------------------------------"
echo " - configration des metriques de la base de données        "
echo "-----------------------------------------------------------"
sudo ${KEYCLOAK_HOME}/bin/jboss-cli.sh --file=${INSTALL_SRC}/config/metrics/db.cli 


echo "-----------------------------------------------------------"
echo " - configration des metriques des les jgroups              "
echo "-----------------------------------------------------------"
sudo ${KEYCLOAK_HOME}/bin/jboss-cli.sh --file=${INSTALL_SRC}/config/metrics/jgroups.cli

