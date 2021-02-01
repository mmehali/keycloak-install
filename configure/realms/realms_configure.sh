#!/usr/bin/env bash

set -euo pipefail

echo "----------------------------------------------"
echo "               Configuration des realms       "
echo "----------------------------------------------"

source /vagrant/configure/realms/master/realm_master.sh
source /vagrant/configure/realms/intranet/realm_intranet.sh
