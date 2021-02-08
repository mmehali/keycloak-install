#!/usr/bin/env bash

set -euo pipefail

echo "----------------------------------------------"
echo " Configuration des realms                     "
echo "----------------------------------------------"

source realms/master/realm_master.sh
source realms/federation/swissid.sh
source realms/intranet/realm_intranet.sh
