#!/usr/bin/env bash

source ./realms/intranet/config.sh



echo " - creation et configuration des utilisateurs"
USER_NAME=myuser
echo "    - creation de l'utilisateur : $USER_NAME"
USER_ID=$(createUser $REALM_NAME $USER_NAME)
echo "    - USER_ID : $USER_ID"
echo "    - mise a jour de l'utilisateur  $USER_NAME"
$KCADM update users/$USER_ID -r $REALM_NAME -s firstName="My" -s lastName="User" -s email="my.user@email.com"
$KCADM set-password -r $REALM_NAME --username $USER_NAME --new-password $USER_NAME

