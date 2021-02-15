#!/usr/bin/env bash

set -euo pipefail

KCADM=/opt/keycloak/bin/kcadm.sh
KEYCLOAK_USER=keycloak
KEYCLOAK_PASSWORD=keycloak
KEYCLOAK_HOST=http://127.0.0.1:8080/auth

echo "--------------------------------------------------------"
echo " Configuration keycloak                                 "
echo "--------------------------------------------------------"

source utils/realm_utils.sh
source utils/user_utils.sh
source utils/client_utils.sh
source utils/provider_utils.sh
source utils/authent_utils.sh

echo " - connexion au serveur $KEYCLOAK_HOST"
$KCADM config credentials --server $KEYCLOAK_HOST --realm master --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD 

source realms/realms_configure.sh
 
#/opt/keycloak/bin/kcadm.sh config credentials --server http://127.0.0.1:8080/auth --realm master --user keycloak --password keycloak 
 