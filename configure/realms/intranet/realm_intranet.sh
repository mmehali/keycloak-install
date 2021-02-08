#!/usr/bin/env bash

#set -euo pipefail

KCADM=/opt/keycloak/bin/kcadm.sh


REALM_NAME='intranet'

echo "------------------------------------------------"
echo "configuration du realm : $REALM_NAME            "
echo "------------------------------------------------"

echo " - creation du realm :$REALM_NAME"
createRealm $REALM_NAME

echo " - configuration  des admin events et login eventsd "

echo "     - active l'enregistrement des "admin events" et leur  representation"
$KCADM update events/config -r ${REALM_NAME} -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true

echo "     - active l'enregistrement des "login events" et defini leur expiration"
$KCADM update events/config -r ${REALM_NAME} -s eventsEnabled=true -s eventsExpiration=259200

echo "     - defini les types de "login event" a enregistrer"
$KCADM update events/config -r ${REALM_NAME} -s 'enabledEventTypes=["CLIENT_DELETE", "CLIENT_DELETE_ERROR", "CLIENT_INFO", "CLIENT_INFO_ERROR", "CLIENT_INITIATED_ACCOUNT_LINKING", "CLIENT_INITIATED_ACCOUNT_LINKING_ERROR", "CLIENT_LOGIN", "CLIENT_LOGIN_ERROR", "CLIENT_REGISTER", "CLIENT_REGISTER_ERROR", "CLIENT_UPDATE", "CLIENT_UPDATE_ERROR", "CODE_TO_TOKEN", "CODE_TO_TOKEN_ERROR", "CUSTOM_REQUIRED_ACTION", "CUSTOM_REQUIRED_ACTION_ERROR", "EXECUTE_ACTIONS", "EXECUTE_ACTIONS_ERROR", "EXECUTE_ACTION_TOKEN", "EXECUTE_ACTION_TOKEN_ERROR", "FEDERATED_IDENTITY_LINK", "FEDERATED_IDENTITY_LINK_ERROR", "GRANT_CONSENT", "GRANT_CONSENT_ERROR", "IDENTITY_PROVIDER_FIRST_LOGIN", "IDENTITY_PROVIDER_FIRST_LOGIN_ERROR", "IDENTITY_PROVIDER_LINK_ACCOUNT", "IDENTITY_PROVIDER_LINK_ACCOUNT_ERROR", "IDENTITY_PROVIDER_LOGIN", "IDENTITY_PROVIDER_LOGIN_ERROR", "IDENTITY_PROVIDER_POST_LOGIN", "IDENTITY_PROVIDER_POST_LOGIN_ERROR", "IDENTITY_PROVIDER_RESPONSE", "IDENTITY_PROVIDER_RESPONSE_ERROR", "IDENTITY_PROVIDER_RETRIEVE_TOKEN", "IDENTITY_PROVIDER_RETRIEVE_TOKEN_ERROR", "IMPERSONATE", "IMPERSONATE_ERROR", "INTROSPECT_TOKEN", "INTROSPECT_TOKEN_ERROR", "INVALID_SIGNATURE", "INVALID_SIGNATURE_ERROR", "LOGIN", "LOGIN_ERROR", "LOGOUT", "LOGOUT_ERROR", "PERMISSION_TOKEN", "PERMISSION_TOKEN_ERROR", "REFRESH_TOKEN", "REFRESH_TOKEN_ERROR", "REGISTER", "REGISTER_ERROR", "REGISTER_NODE", "REGISTER_NODE_ERROR", "REMOVE_FEDERATED_IDENTITY", "REMOVE_FEDERATED_IDENTITY_ERROR", "REMOVE_TOTP", "REMOVE_TOTP_ERROR", "RESET_PASSWORD", "RESET_PASSWORD_ERROR", "RESTART_AUTHENTICATION", "RESTART_AUTHENTICATION_ERROR", "REVOKE_GRANT", "REVOKE_GRANT_ERROR", "SEND_IDENTITY_PROVIDER_LINK", "SEND_IDENTITY_PROVIDER_LINK_ERROR", "SEND_RESET_PASSWORD", "SEND_RESET_PASSWORD_ERROR", "SEND_VERIFY_EMAIL", "SEND_VERIFY_EMAIL_ERROR", "TOKEN_EXCHANGE", "TOKEN_EXCHANGE_ERROR", "UNREGISTER_NODE", "UNREGISTER_NODE_ERROR", "UPDATE_CONSENT", "UPDATE_CONSENT_ERROR", "UPDATE_EMAIL", "UPDATE_EMAIL_ERROR", "UPDATE_PASSWORD", "UPDATE_PASSWORD_ERROR", "UPDATE_PROFILE", "UPDATE_PROFILE_ERROR", "UPDATE_TOTP", "UPDATE_TOTP_ERROR", "USER_INFO_REQUEST", "USER_INFO_REQUEST_ERROR", "VALIDATE_ACCESS_TOKEN", "VALIDATE_ACCESS_TOKEN_ERROR", "VERIFY_EMAIL", "VERIFY_EMAIL_ERROR"]'



echo " - creation et configuration des clients              "
CLIENT_ID=PortailSmacl

echo "     - creattion du client $CLIENT_ID " 
 
ID=$(createClient $REALM_NAME $CLIENT_ID)
$KCADM update clients/$ID -r $REALM_NAME -s name="My Client" -s protocol=openid-connect -s publicClient=true -s standardFlowEnabled=true -s 'redirectUris=["https://www.keycloak.org/app/*"]' -s baseUrl="https://www.keycloak.org/app/" -s 'webOrigins=["*"]'

echo " - creation et configuration des utilisateurs"
USER_NAME=myuser
echo "    - creation de l'utilisateur : $USER_NAME"
USER_ID=$(createUser $REALM_NAME $USER_NAME)
echo "    - USER_ID : $USER_ID"
echo "    - mise a jour de l'utilisateur  $USER_NAME"
$KCADM update users/$USER_ID -r $REALM_NAME -s firstName="My" -s lastName="User" -s email="my.user@email.com"
$KCADM set-password -r $REALM_NAME --username $USER_NAME --new-password $USER_NAME


echo " - creation et configuration d'une federation Ldap"

PROVIDER_NAME=ldap-provider-3

REALM_ID=$(/opt/keycloak/bin/kcadm.sh get realms/$REALM_NAME --fields id --format csv --noquotes)
echo "      - get REALM_ID :$REALM_ID " 

echo "      - creation de ldap-provider $PROVIDER_NAME" 
/opt/keycloak/bin/kcadm.sh create components -r $REALM_NAME -s name=$PROVIDER_NAME -s parentId=$REALM_ID -s providerId=ldap -s providerType=org.keycloak.storage.UserStorageProvider -s 'config.priority=["1"]' -s 'config.enabled=["true"]' -s 'config.fullSyncPeriod=["-1"]' -s 'config.changedSyncPeriod=["-1"]' -s 'config.cachePolicy=["DEFAULT"]' -s 'config.evictionDay=[]' -s 'config.evictionHour=[]' -s  config.evictionMinute=[] -s  config.maxLifespan=[] -s 'config.batchSizeForSync=["1000"]' -s 'config.editMode=["READ_ONLY"]' -s 'config.syncRegistrations=["false"]' -s 'config.vendor=["other"]' -s 'config.usernameLDAPAttribute=["uid"]' -s 'config.rdnLDAPAttribute=["uid"]' -s 'config.uuidLDAPAttribute=["entryUUID"]' -s 'config.userObjectClasses=["inetOrgPerson, organizationalPerson"]' -s 'config.connectionUrl=["ldap://ldapdev.smacl.lan:389"]' -s 'config.usersDn=["ou=Utilisateurs,dc=smacl,dc=lan"]' -s 'config.authType=["simple"]' -s 'config.bindDn=["cn=lectureseule,ou=Applications,dc=smac,dc=lan"]' -s 'config.bindCredential=["lectureseule"]' -s 'config.searchScope=["1"]' -s 'config.useTruststoreSpi=["ldapsOnly"]' -s 'config.connectionPooling=["true"]' -s 'config.pagination=["true"]' -s 'config.allowKerberosAuthentication=["false"]'
#/opt/keycloak/bin/kcadm.sh create components -r $REALM_NAME -s name=dlab-ldap      -s parentId=$REALM_ID -s providerId=ldap -s providerType=org.keycloak.storage.UserStorageProvider -s 'config.priority=["1"]'                              -s 'config.fullSyncPeriod=["-1"]' -s 'config.changedSyncPeriod=["-1"]' -s 'config.cachePolicy=["DEFAULT"]' -s  config.evictionDay=[]  -s  config.evictionHour=[]  -s  config.evictionMinute=[] -s  config.maxLifespan=[] -s 'config.batchSizeForSync=["1000"]' -s 'config.editMode=["READ_ONLY"]' -s 'config.syncRegistrations=["false"]' -s 'config.vendor=["other"]' -s 'config.usernameLDAPAttribute=["$ }"]' -s 'config.rdnLDAPAttribute=["${}"]' -s 'config.uuidLDAPAttribute=["${tr}"]'     -s 'config.userObjectClasses=["inetOrgPerson, organizationalPerson"]' -s 'config.connectionUrl=["ldap://${ldap_host}:389"]'      -s 'config.usersDn=["${ldap_users_group},${ldap_dn}"]'  -s 'config.authType=["simple"]' -s 'config.bindDn=["${ldap_user},${ldap_dn}"]'                        -s 'config.bindCredential=["${ldap_bi}"]'   -s 'config.searchScope=["1"]' -s 'config.useTruststoreSpi=["ldapsOnly"]' -s 'config.connectionPooling=["true"]' -s 'config.pagination=["true"]' --server http://127.0.0.1:8080/auth



echo "Create user federation group mapper"
user_f_id=$(/opt/keycloak/bin/kcadm.sh get components -r intranet --query name=$PROVIDER_NAME | /usr/bin/jq -er '.[].id')

/opt/keycloak/bin/kcadm.sh create components -r intranet -s name=group_mapper -s providerId=group-ldap-mapper \
          -s providerType=org.keycloak.storage.ldap.mappers.LDAPStorageMapper -s parentId=$user_f_id \
          -s 'config."groups.dn"=["ou=Groups,${ldap_dn}"]' -s 'config."group.name.ldap.attribute"=["cn"]' \
          -s 'config."group.object.classes"=["posixGroup"]' -s 'config."preserve.group.inheritance"=["false"]' \
          -s 'config."membership.ldap.attribute"=["memberUid"]' -s 'config."membership.attribute.type"=["UID"]' \
          -s 'config."groups.ldap.filter"=[]' -s 'config.mode=["IMPORT"]' \
          -s 'config."user.roles.retrieve.strategy"=["LOAD_GROUPS_BY_MEMBER_ATTRIBUTE"]' \
          -s 'config."mapped.group.attributes"=[]' -s 'config."drop.non.existing.groups.during.sync"=["false"]'
          
echo "Declancher la synchronization de tous les utilisateurs pour une federation specifique"
# Use the storage provider’s id attribute to compose an endpoint URI, such as 
# user-storage/ID_OF_USER_STORAGE_INSTANCE/sync.
# Add the action=triggerFullSync query parameter and run the create command.
/opt/keycloak/bin/kcadm.sh create user-storage/$PROVIDER_ID/sync?action=triggerFullSync


        
echo " - creation du mapper :portailSmaclRoleMapper -------------------"
MAPPER_NAME=PortailSmaclRoleMapper
           
PROVIDER_ID=$(/opt/keycloak/bin/kcadm.sh get components -r $REALM_NAME -q name=$PROVIDER_NAME  --fields id --format csv --noquotes)
echo "PROVIDER_ID :$PROVIDER_ID"
echo "MAPPER_NANE :$MAPPER_NAME"
echo "      - creation du mapper $MAPPER_NAME"
   
/opt/keycloak/bin/kcadm.sh create components -r intranet -s name=$MAPPER_NAME -s providerId=role-ldap-mapper -s providerType=org.keycloak.storage.ldap.mappers.LDAPStorageMapper -s parentId=$user_f_id -s 'config."roles.dn"=["ou=PortailSmacl,ou=ApplicationsTHEMIS,dc=smacl,dc=lan"]' -s 'config."mode"=["READ_ONLY"]' -s 'config."role.name.ldap.attribute"=["CN"]' -s 'config."role.object.classes"=["groupOfNames"]' -s 'config."membership.attribute.type"=["DN"]' -s 'config."user.roles.retrieve.strategy"=["LOAD_ROLES_BY_MEMBER_ATTRIBUTE"]' -s 'config."membership.ldap.attribute"=["member"]' -s 'config."membership.user.ldap.attribute"=["uid"]' -s 'config."memberof.ldap.attribute"=["memberOf"]' -s 'config."use.realm.roles.mapping"=["false"]' -s 'config."client.id"=["PortailSmacl"]' 
     


# Listing assigned, available, and effective client roles for a user
# Use a dedicated get-roles command to list assigned, available, and effective client roles for a user.
#  to list assigned client roles for the user, specify the :
#     - target user by either a user name (via the --uusername option) or an ID (via the --uid option) and 
#     - client by either a clientId attribute (via the --cclientid option) or an ID (via the --cid option).

$ /opt/keycloak/bin/kcadm.sh get-roles -r demorealm --uusername testuser --cclientid realm-management

#Use the additional --effective option to list effective realm roles.
/opt/keycloak/bin/kcadm.sh get-roles -r demorealm --uusername testuser --cclientid realm-management --effective

#Use the --available option to list realm roles that can still be added to the user.
/opt/keycloak/bin/kcadm.sh get-roles -r demorealm --uusername testuser --cclientid realm-management --available


echo "- configuring a SAML 2 identity provider"
# - providerId=saml.
# - fournit les attributss: singleSignOnServiceUrl, nameIDPolicyFormat, and signatureAlgorithm.
/opt/keycloak/bin/kcadm.sh create identity-provider/instances -r intranet -s alias=saml-alias -s providerId=saml -s enabled=true -s 'config.useJwksUrl="true"' -s config.singleSignOnServiceUrl=http://localhost:8180/auth/realms/saml-broker-realm/protocol/saml -s config.nameIDPolicyFormat=urn:oasis:names:tc:SAML:2.0:nameid-format:persistent -s config.signatureAlgorithm=RSA_SHA256

echo " - saml provider mapper saml-role-idp-mapper"
/opt/keycloak/bin/kcadm.sh create identity-provider/instances/saml-alias/mappers -r intranet -s identityProviderAlias=saml-alias -s name="role-mapper-name" -s identityProviderMapper=saml-role-idp-mapper


echo " - Configuring a Keycloak OpenID Connect identity provider"
# - providerId=keycloak-oidc 
# - fournir les attributs: authorizationUrl, tokenUrl, clientId, and clientSecret.

/opt/keycloak/bin/kcadm.sh create identity-provider/instances -r intranet -s alias=keycloak-oidc-alias -s providerId=keycloak-oidc -s enabled=true -s 'config.useJwksUrl="true"' -s config.authorizationUrl=http://localhost:8180/auth/realms/intranet/protocol/openid-connect/auth -s config.tokenUrl=http://localhost:8180/auth/realms/intranet/protocol/openid-connect/token -s config.clientId=demo-oidc-provider -s config.clientSecret=secret


#-------------------------------------------------------------
#############
# identity providers
# swissid
IDENTITY_PROVIDER_ALIAS='swissid'
createIdentityProvider $REALM_NAME $IDENTITY_PROVIDER_ALIAS "SwissID" oidc
$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS -r $REALM_NAME -s trustEmail=true -s 'config={"clientId": "'$CLIENT_ID_ISSUED_BY_SWISSID'", "clientSecret" : "'CLIENT_SECRET_ISSUED_BY_SWISSID'", "tokenUrl": "https://login.int.swissid.ch:443/idp/oauth2/access_token", "validateSignature": "true", "useJwksUrl": "true", "jwksUrl": "https://login.int.swissid.ch:443/idp/oauth2/connect/jwk_uri", "authorizationUrl": "https://login.int.swissid.ch:443/idp/oauth2/authorize", "clientAuthMethod": "client_secret_post", "syncMode": "FORCE", "defaultScope": "openid profile email address" }'
# mappers
MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "given_name -> firstName" oidc-user-attribute-idp-mapper)
$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "given_name",  "user.attribute": "firstName"}'

MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "family_name -> lastName" oidc-user-attribute-idp-mapper)
$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "family_name", "user.attribute": "lastName"}'

MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "gender -> gender" oidc-user-attribute-idp-mapper)
$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "gender",      "user.attribute": "gender"}'

MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "language -> language" oidc-user-attribute-idp-mapper)
$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "language",    "user.attribute": "language"}'

#############
# authentication

# in the `browser` flow the identity provider redirector is set as default (= no login screen should be displayed)
EXECUTION_ID=$(getExecution $REALM_NAME browser identity-provider-redirector)
$KCADM create authentication/executions/$EXECUTION_ID/config -r $REALM_NAME -b '{"config":{"defaultProvider":"'$IDENTITY_PROVIDER_ALIAS'"},"alias":"'$IDENTITY_PROVIDER_ALIAS'"}'




#-------------------------------------------------------------
echo " get toplevel flow"
/opt/keycloak/bin/kcadm.sh get authentication/flows -r intranet --fields id,alias| jq '.[] | select(.alias==("'$ALIAS'")) | .id')

/opt/keycloak/bin/kcadm.sh create components -r intranet -f << EOF 
{ 
  "name": "${MAPPER_NAME}-new", 
  "providerId": "role-ldap-mapper", 
  "parentId": "${PROVIDER_ID}", 
   "providerType": "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",  
   "config": { 
      "mode": [\"READ_ONLY\"],
      "membership.attribute.type": [\"DN\"], 
      "user.roles.retrieve.strategy": [\"LOAD_ROLES_BY_MEMBER_ATTRIBUTE\"], 
      "roles.dn": [\"ou=PortailSmacl,ou=ApplicationsTHEMIS,dc=smacl,dc=lan\"],  
      "membership.ldap.attribute": [\"member\"], 
      "membership.user.ldap.attribute": [\"uid\"],  
      "memberof.ldap.attribute": [\"memberOf\"], 
      "role.name.ldap.attribute": [\"CN\"], 
      "use.realm.roles.mapping": [\"false\"],  
      "client.id": [\"PortailSmacl\"], 
      "role.object.classes": [\"groupOfNames\"] 
      } 
  }
EOF
    
#/opt/keycloak/bin/kcadm.sh create components -r $REALM_NAME -s name=hardcoded-ldap-role-mapper -s providerId=hardcoded-ldap-role-mapper -s providerType=org.keycloak.storage.ldap.mappers.LDAPStorageMapper -s parentId=$PARENT_ID -s 'config.role=["realm-management.create-client"]'
