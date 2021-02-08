#!/usr/bin/env bash

INSTALL_SRC=/opt/keycloak-install
KEYCLOAK_HOME=/opt/keycloak


echo " - configuration des caches owners à 2 replicas"
echo "Activation de la replication sur le cache AuthenticationSessions avec 2 replicas"
"${KEYCLOAK_HOME}"/bin/jboss-cli.sh --file=${INSTALL_SRC}/config/infinispan/cache-owners.cli
  