#!/usr/bin/env bash

source ./realms/intranet/config.sh

echo "- configuring a SAML 2 identity provider"
# - providerId=saml.
PROVIDER_ALIAS=saml-alias
PROVIDER_ID=saml
singleSignOnServiceUrl=http://localhost:8180/auth/realms/saml-broker-realm/protocol/saml

$KCADM create identity-provider/instances -r $REALM_NAME \
  -s alias=$PROVIDER_ALIAS \
  -s providerId=$PROVIDER_ID \
  -s enabled=true \
  -s 'config.useJwksUrl="true"' \
  -s config.singleSignOnServiceUrl=$singleSignOnServiceUrl \
  -s config.nameIDPolicyFormat=urn:oasis:names:tc:SAML:2.0:nameid-format:persistent \
  -s config.signatureAlgorithm=RSA_SHA256

echo " - saml provider mapper saml-role-idp-mapper"
$KCADM create identity-provider/instances/$PROVIDER_ALIAS/mappers -r intranet -s identityProviderAlias=saml-alias -s name="role-mapper-name" -s identityProviderMapper=saml-role-idp-mapper

