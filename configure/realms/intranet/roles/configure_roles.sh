#!/usr/bin/env bash

source ./realms/intranet/config.sh

USERNAME=myuser

# Listing assigned, available, and effective client roles for a user
# Use a dedicated get-roles command to list assigned, available, and effective client roles for a user.
#  to list assigned client roles for the user, specify the :
#     - target user by either a user name (via the --uusername option) or an ID (via the --uid option) and 
#     - client by either a clientId attribute (via the --cclientid option) or an ID (via the --cid option).


#$KCADM get-roles -r  $REALM_NAME --uusername $USERNAME --cclientid realm-management

#Use the additional --effective option to list effective realm roles.
#$KCADM get-roles -r $REALM_NAME --uusername $USERNAME --cclientid realm-management --effective

#Use the --available option to list realm roles that can still be added to the user.
#$KCADM get-roles -r $REALM_NAME --uusername $USERNAME --cclientid realm-management --available

