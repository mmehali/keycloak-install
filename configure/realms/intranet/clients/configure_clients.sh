#!/usr/bin/env bash

source ./realms/intranet/config.sh

echo ""
echo "- creation et configuration des clients              "

CLIENT_ID=PortailSmacl

echo "  - creattion du client : $CLIENT_ID " 
 
ID=$(createClient $REALM_NAME $CLIENT_ID)
$KCADM update clients/$ID -r $REALM_NAME -s name=$CLIENT_ID -s protocol=openid-connect -s publicClient=true -s standardFlowEnabled=true -s 'redirectUris=["https://www.keycloak.org/app/*"]' -s baseUrl="https://www.keycloak.org/app/" -s 'webOrigins=["*"]'

