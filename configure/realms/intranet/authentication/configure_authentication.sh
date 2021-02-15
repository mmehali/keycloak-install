#!/usr/bin/env bash

source ./realms/intranet/config.sh

IDENTITY_PROVIDER_ALIAS="keycloak-oidc-alias"


#-------------------------------------------------------------
#echo " get toplevel flow"
#$KCADM get authentication/flows -r $REALM_NAME --fields id,alias| jq '.[] | select(.alias==("'$ALIAS'")) | .id')

echo " configuration authentification : cacher la mire."
# in the `browser` flow the identity provider redirector is set as default (= no login screen should be displayed)
EXECUTION_ID=$(getExecution $REALM_NAME browser identity-provider-redirector)
$KCADM create authentication/executions/$EXECUTION_ID/config -r $REALM_NAME -s config.defaultProvider=$IDENTITY_PROVIDER_ALIAS -s alias=$IDENTITY_PROVIDER_ALIAS


#getExecution() {
#    REALM=$1
#    FLOW_ID=$2
#    PROVIDER_ID=$3
#    #
#    EXECUTION_ID=$($KCADM get authentication/flows/$FLOW_ID/executions -r $REALM --fields providerId,id | jq '.[] | select(.providerId==("'$PROVIDER_ID'")) |.id')
#    echo $(sed -e 's/"//g' <<< $EXECUTION_ID)
#}
