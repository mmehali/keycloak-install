#!/usr/bin/env bash

set -euo pipefail

KCADM=/opt/keycloak/bin/kcadm.sh


REALM_NAME='intranet'

echo "------------------------------------------------"
echo "configuration du realm : $REALM_NAME            "
echo "------------------------------------------------"

echo " - creation du realm :$REAML_NAME"
createRealm $REALM_NAME

echo "-------------------------------------------------"
echo "configuration  des admin events et login eventsd "
echo "-------------------------------------------------"

echo " - active l'enregistrement des "admin events" et leur  representation"
$KCADM update events/config -r ${REALM_NAME} -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true

echo " - active l'enregistrement des "login events" et defini leur expiration"
$KCADM update events/config -r ${REALM_NAME} -s eventsEnabled=true -s eventsExpiration=259200

echo " - defini les types de "login event" a enregistrer"
$KCADM update events/config -r ${REALM_NAME} -s 'enabledEventTypes=["CLIENT_DELETE", "CLIENT_DELETE_ERROR", "CLIENT_INFO", "CLIENT_INFO_ERROR", "CLIENT_INITIATED_ACCOUNT_LINKING", "CLIENT_INITIATED_ACCOUNT_LINKING_ERROR", "CLIENT_LOGIN", "CLIENT_LOGIN_ERROR", "CLIENT_REGISTER", "CLIENT_REGISTER_ERROR", "CLIENT_UPDATE", "CLIENT_UPDATE_ERROR", "CODE_TO_TOKEN", "CODE_TO_TOKEN_ERROR", "CUSTOM_REQUIRED_ACTION", "CUSTOM_REQUIRED_ACTION_ERROR", "EXECUTE_ACTIONS", "EXECUTE_ACTIONS_ERROR", "EXECUTE_ACTION_TOKEN", "EXECUTE_ACTION_TOKEN_ERROR", "FEDERATED_IDENTITY_LINK", "FEDERATED_IDENTITY_LINK_ERROR", "GRANT_CONSENT", "GRANT_CONSENT_ERROR", "IDENTITY_PROVIDER_FIRST_LOGIN", "IDENTITY_PROVIDER_FIRST_LOGIN_ERROR", "IDENTITY_PROVIDER_LINK_ACCOUNT", "IDENTITY_PROVIDER_LINK_ACCOUNT_ERROR", "IDENTITY_PROVIDER_LOGIN", "IDENTITY_PROVIDER_LOGIN_ERROR", "IDENTITY_PROVIDER_POST_LOGIN", "IDENTITY_PROVIDER_POST_LOGIN_ERROR", "IDENTITY_PROVIDER_RESPONSE", "IDENTITY_PROVIDER_RESPONSE_ERROR", "IDENTITY_PROVIDER_RETRIEVE_TOKEN", "IDENTITY_PROVIDER_RETRIEVE_TOKEN_ERROR", "IMPERSONATE", "IMPERSONATE_ERROR", "INTROSPECT_TOKEN", "INTROSPECT_TOKEN_ERROR", "INVALID_SIGNATURE", "INVALID_SIGNATURE_ERROR", "LOGIN", "LOGIN_ERROR", "LOGOUT", "LOGOUT_ERROR", "PERMISSION_TOKEN", "PERMISSION_TOKEN_ERROR", "REFRESH_TOKEN", "REFRESH_TOKEN_ERROR", "REGISTER", "REGISTER_ERROR", "REGISTER_NODE", "REGISTER_NODE_ERROR", "REMOVE_FEDERATED_IDENTITY", "REMOVE_FEDERATED_IDENTITY_ERROR", "REMOVE_TOTP", "REMOVE_TOTP_ERROR", "RESET_PASSWORD", "RESET_PASSWORD_ERROR", "RESTART_AUTHENTICATION", "RESTART_AUTHENTICATION_ERROR", "REVOKE_GRANT", "REVOKE_GRANT_ERROR", "SEND_IDENTITY_PROVIDER_LINK", "SEND_IDENTITY_PROVIDER_LINK_ERROR", "SEND_RESET_PASSWORD", "SEND_RESET_PASSWORD_ERROR", "SEND_VERIFY_EMAIL", "SEND_VERIFY_EMAIL_ERROR", "TOKEN_EXCHANGE", "TOKEN_EXCHANGE_ERROR", "UNREGISTER_NODE", "UNREGISTER_NODE_ERROR", "UPDATE_CONSENT", "UPDATE_CONSENT_ERROR", "UPDATE_EMAIL", "UPDATE_EMAIL_ERROR", "UPDATE_PASSWORD", "UPDATE_PASSWORD_ERROR", "UPDATE_PROFILE", "UPDATE_PROFILE_ERROR", "UPDATE_TOTP", "UPDATE_TOTP_ERROR", "USER_INFO_REQUEST", "USER_INFO_REQUEST_ERROR", "VALIDATE_ACCESS_TOKEN", "VALIDATE_ACCESS_TOKEN_ERROR", "VERIFY_EMAIL", "VERIFY_EMAIL_ERROR"]'



echo "-------------------------------------------------------------"
echo "creation et configuration des clients realm : $REALM_NAME    "
echo "-------------------------------------------------------------"

CLIENT_ID=myclient
ID=$(createClient $REALM_NAME $CLIENT_ID)
$KCADM update clients/$ID -r $REALM_NAME -s name="My Client" -s protocol=openid-connect -s publicClient=true -s standardFlowEnabled=true -s 'redirectUris=["https://www.keycloak.org/app/*"]' -s baseUrl="https://www.keycloak.org/app/" -s 'webOrigins=["*"]'



echo "-------------------------------------------------------------"
echo "creation et configuration des utilisateurs realm : $REALM_NAME    "
echo "-------------------------------------------------------------"
USER_NAME=myuser
USER_ID=$(createUser $REALM_NAME $USER_NAME)
$KCADM update users/$USER_ID -r $REALM_NAME -s firstName="My" -s lastName="User" -s email="my.user@email.com"
$KCADM set-password -r $REALM_NAME --username $USER_NAME --new-password $USER_NAME

