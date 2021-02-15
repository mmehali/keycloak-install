
#!/usr/bin/env bash

source ./realms/intranet/config.sh


echo " - Configuring a Keycloak OpenID Connect identity provider"
# - providerId=keycloak-oidc 
IDENTITY_PROVIDER_ALIAS=keycloak-oidc-alias
NAME=oidc_identity_provider
$KCADM  create identity-provider/instances -r $REALM_NAME \
 -s alias=$IDENTITY_PROVIDER_ALIAS \
 -s displayName="$NAME" \
 -s providerId=keycloak-oidc \
 -s enabled=true  
  
echo " - update de $NAME"  
$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS -r $REALM_NAME -s 'trustEmail="true"' -s 'config.clientId="CLIENT_ID_ISSUED_BY_SMACLCONNECT"' -s 'config.clientSecret="CLIENT_SECRET_ISSUED_BY_SWISSID"' -s 'config.tokenUrl="https://login.int.swissid.ch:443/idp/oauth2/access_token"' -s 'config.validateSignature="true"' -s 'config.useJwksUrl="true"' -s 'config.jwksUrl="https://login.int.swissid.ch:443/idp/oauth2/connect/jwk_uri"' -s 'config.authorizationUrl="https://login.int.swissid.ch:443/idp/oauth2/authorize"' -s 'config.clientAuthMethod="client_secret_post"' -s 'config.syncMode="FORCE"' -s 'config.defaultScope="openid profile email address"' 
  
  
#MAPPER_NAME="given_name -> firstName"
#MAPPER_TYPE=oidc-user-attribute-idp-mapper  
#echo "   creation du mapper [$MAPPER_NAME] de type [$MAPPER_TYPE]"
#MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS $MAPPER_NAME $MAPPER_TYPE)
#$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "given_name",  "user.attribute": "firstName"}'


# mappers
#MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "given_name -> firstName" oidc-user-attribute-idp-mapper)
#$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "given_name",  "user.attribute": "firstName"}'

#MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "family_name -> lastName" oidc-user-attribute-idp-mapper)
#$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "family_name", "user.attribute": "lastName"}'

#MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "gender -> gender" oidc-user-attribute-idp-mapper)
#$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "gender",      "user.attribute": "gender"}'

#MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "language -> language" oidc-user-attribute-idp-mapper)
#$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "language",    "user.attribute": "language"}'


