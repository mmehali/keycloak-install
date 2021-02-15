#!/usr/bin/env bash

source ./realms/intranet/config.sh

echo ""
echo "- creation et configuration des clients              "

applis=`ldapsearch -LLL -x  -H  ldap://ldapdev.smacl.lan:389  -D cn=lectureseule,ou=Applications,dc=smacl,dc=lan  -w lectureseule  -b ou=ApplicationsTHEMIS,dc=smacl,dc=lan -s sub "(&(object
class=groupOfNames))" 1.1|awk '!/^$/'|sed '/^$/d'|awk -F "dn:" '{print $2 }'|awk -F "," '{print $2}'|awk -F "=" '{print $2}' | sort|uniq`

for app in $applis
do
  echo "create client : $app"
  ID=$(createClient $REALM_NAME $app)
  $KCADM update clients/$ID -r $REALM_NAME -s name=$app -s protocol=openid-connect -s publicClient=true -s standardFlowEnabled=true -s 'redirectUris=["https://www.keycloak.org/app/*"]' -s baseUrl="https://www.keycloak.org/app/" -s 'webOrigins=["*"]'
done
