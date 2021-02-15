#!/usr/bin/env bash

source ./realms/intranet/config.sh

echo ""
echo "- creation et configuration des clients              "

CLIENT_ID=PortailSmacl

echo "  - creattion du client : $CLIENT_ID "

/opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user keycloak --password keycloak 

REALM_CERTIFICATE=$(/opt/keycloak/bin/kcadm.sh get keys -r intranet|jq -r '.keys[0].certificate')
REALM_PUBLIC_KEY=$(/opt/keycloak/bin/kcadm.sh get keys -r intranet |jq -r '.keys[0].publicKey')

echo "REALM_CERTIFICATE:$REALM_CERTIFICATE"
echo ""
echo "REALM_PUBLIC_KEY:$REALM_PUBLIC_KEY"

/opt/keycloak/bin/kcadm.sh create clients -r intranet \
 -s "clientId"="http://yourRancherHostUrl/v1-saml/keycloak/saml/metadata" \
 -s "name"="Rancher" \
 -s "protocol"="saml" \
 -s "surrogateAuthRequired"=false \
 -s "enabled"=true \
 -s "alwaysDisplayInConsole"=false \
 -s "clientAuthenticatorType"="client-secret" \
 -s "secret"="**********" \
 -s '"redirectUris"=["http://yourRancherHostUrl/v1-saml/keycloak/saml/acs"]' \
 -s '"webOrigins"=[]' \
 -s "notBefore"=0 \
 -s "bearerOnly"=false \
 -s "consentRequired"=false \
 -s "standardFlowEnabled"=true \
 -s "implicitFlowEnabled"=false \
 -s "directAccessGrantsEnabled"=false \
 -s "serviceAccountsEnabled"=false \
 -s "publicClient"=false \
 -s "frontchannelLogout"=false \
 -s '"attributes"."saml.assertion.signature"="true"' \
 -s '"attributes"."saml.force.post.binding"="false"' \
 -s '"attributes"."saml.multivalued.roles"="false"' \
 -s '"attributes"."saml.encrypt"="false"' \
 -s '"attributes"."saml.server.signature"="true"' \
 -s '"attributes"."saml.server.signature.keyinfo.ext"="false"' \
 -s '"attributes"."exclude.session.state.from.auth.response"="false"' \
 #-s '"attributes"."saml.signing.certificate"="$REALM_CERTIFICATE"' \                                              
 -s '"attributes"."saml.signature.algorithm"="RSA_SHA256"' \
 -s '"attributes"."saml_force_name_id_format"="false"' \
 -s '"attributes"."saml.client.signature"="false"' \
 -s '"attributes"."tls.client.certificate.bound.access.tokens"="false"' \
 -s '"attributes"."saml.authnstatement"="false"' \
 -s '"attributes"."display.on.consent.screen"="false"' \
 #-s '"attributes"."saml.signing.private.key"="$REALM_PUBLIC_KEY"' \                                                                                           
 -s '"attributes"."saml_name_id_format"="username"' \
 -s '"attributes"."saml.onetimeuse.condition"="false"' \
 -s '"attributes"."saml_signature_canonicalization_method"="http://www.w3.org/2001/10/xml-exc-c14n#"' \
 -s '"authenticationFlowBindingOverrides"={}' \
 -s "fullScopeAllowed"=true \
 -s "nodeReRegistrationTimeout"=-1 
 