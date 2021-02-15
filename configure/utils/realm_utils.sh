#!/usr/bin/env bash

# creation et activation d'un nouveau realm.
# le realm n'est cree que s'il n'exite pas.
createRealm() {
  # arguments
  REALM_NAME=$1
  
  #REALM_EXIST=$($KCADM get realms/$REALM_NAME)
  #if [ "$REALM_EXIST" == "" ]; then
    $KCADM create realms -s realm="${REALM_NAME}" -s enabled=true
    #$KCADM create realms -s realm="${REALM_NAME}" -s enabled=true -s loginTheme=dlab -s sslRequired=none
  #fi
}
