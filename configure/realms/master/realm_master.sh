#!/usr/bin/env bash

source ./realms/master/config.sh


echo " "
echo " "
echo "---------------------------------------"
echo " configuration du realm : $REALM_NAME  "
echo "---------------------------------------"
source ./realms/master/events/configure_events.sh
