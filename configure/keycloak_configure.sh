#!/usr/bin/env bash

set -euo pipefail

KCADM=/opt/keycloak/bin/kcadm.sh
KEYCLOAK_USER=admin
KEYCLOAK_PASSWORD=admin
HOST_FOR_KCADM=localhost
echo "--------------------------------------------------------"
echo "        Configuration keycloak                          "
echo "--------------------------------------------------------"

source /vagrant/configure/utils/realm_utils.sh
source /vagrant/configure/utils/user_utils.sh
source /vagrant/configure/utils/client_utils.sh

$KCADM config credentials --server http://$HOST_FOR_KCADM:8080/auth --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD --realm master

source /vagrant/configure/realms/realms_configure.sh

