#!/usr/bin/env bash

echo "----------------------------------------------"
echo " Configuration des realms                     "
echo "----------------------------------------------"

source realms/master/realm_master.sh
source realms/intranet/realm_intranet.sh
source realms/federation/smacl_connect.sh

