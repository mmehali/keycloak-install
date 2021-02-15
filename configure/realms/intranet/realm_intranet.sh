#!/usr/bin/env bash

source ./realms/intranet/config.sh

echo " suppression du realm :$REALM_NAME"
$KCADM delete realms/$REALM_NAME

echo ""
echo "------------------------------------------------"
echo " configuration du realm : $REALM_NAME           "
echo "------------------------------------------------"

echo " - creation du realm :$REALM_NAME"
createRealm $REALM_NAME

# configuration des evenements
source ./realms/intranet/events/configure_events.sh

# configuration du realm 
source ./realms/intranet/realm-settings/realm_settings.sh


# configurations des utilisateurs 
source ./realms/intranet/users/configure_users.sh

# configuration des clients 
source ./realms/intranet/clients/configure_clients.sh

#configuration des roles 
source ./realms/intranet/roles/configure_roles.sh

# creation et configuration d'une federation Ldap"
source ./realms/intranet/user-federation/configure_federation.sh

# creation et configuration des identity-providers"
source ./realms/intranet/identity-providers/configure_identity_providers.sh



# creation et configuration d'une federation Ldap"
source ./realms/intranet/authentication/configure_authentication.sh








