#!/usr/bin/env bash

source ./realms/intranet/config.sh

PROVIDER_NAME=ldap-provider-3

echo " - creation de la federation : $PROVIDER_NAME "

REALM_ID=$(/opt/keycloak/bin/kcadm.sh get realms/$REALM_NAME --fields id --format csv --noquotes)
echo "      ${REALM_NAME} id : $REALM_ID " 

echo "      - creation de ldap-provider $PROVIDER_NAME" 
$KCADM create components -r $REALM_NAME -s name=$PROVIDER_NAME -s parentId=$REALM_ID -s providerId=ldap -s providerType=org.keycloak.storage.UserStorageProvider -s 'config.priority=["1"]' -s 'config.enabled=["true"]' -s 'config.fullSyncPeriod=["-1"]' -s 'config.changedSyncPeriod=["-1"]' -s 'config.cachePolicy=["DEFAULT"]' -s 'config.evictionDay=[]' -s 'config.evictionHour=[]' -s  config.evictionMinute=[] -s  config.maxLifespan=[] -s 'config.batchSizeForSync=["1000"]' -s 'config.editMode=["READ_ONLY"]' -s 'config.syncRegistrations=["false"]' -s 'config.vendor=["other"]' -s 'config.usernameLDAPAttribute=["uid"]' -s 'config.rdnLDAPAttribute=["uid"]' -s 'config.uuidLDAPAttribute=["entryUUID"]' -s 'config.userObjectClasses=["inetOrgPerson, organizationalPerson"]' -s 'config.connectionUrl=["ldap://ldapdev.smacl.lan:389"]' -s 'config.usersDn=["ou=Utilisateurs,dc=smacl,dc=lan"]' -s 'config.authType=["simple"]' -s 'config.bindDn=["cn=lectureseule,ou=Applications,dc=smac,dc=lan"]' -s 'config.bindCredential=["lectureseule"]' -s 'config.searchScope=["1"]' -s 'config.useTruststoreSpi=["ldapsOnly"]' -s 'config.connectionPooling=["true"]' -s 'config.pagination=["true"]' -s 'config.allowKerberosAuthentication=["false"]'
#$KCADM create components -r $REALM_NAME -s name=dlab-ldap      -s parentId=$REALM_ID -s providerId=ldap -s providerType=org.keycloak.storage.UserStorageProvider -s 'config.priority=["1"]'                              -s 'config.fullSyncPeriod=["-1"]' -s 'config.changedSyncPeriod=["-1"]' -s 'config.cachePolicy=["DEFAULT"]' -s  config.evictionDay=[]  -s  config.evictionHour=[]  -s  config.evictionMinute=[] -s  config.maxLifespan=[] -s 'config.batchSizeForSync=["1000"]' -s 'config.editMode=["READ_ONLY"]' -s 'config.syncRegistrations=["false"]' -s 'config.vendor=["other"]' -s 'config.usernameLDAPAttribute=["$ }"]' -s 'config.rdnLDAPAttribute=["${}"]' -s 'config.uuidLDAPAttribute=["${tr}"]'     -s 'config.userObjectClasses=["inetOrgPerson, organizationalPerson"]' -s 'config.connectionUrl=["ldap://${ldap_host}:389"]'      -s 'config.usersDn=["${ldap_users_group},${ldap_dn}"]'  -s 'config.authType=["simple"]' -s 'config.bindDn=["${ldap_user},${ldap_dn}"]'                        -s 'config.bindCredential=["${ldap_bi}"]'   -s 'config.searchScope=["1"]' -s 'config.useTruststoreSpi=["ldapsOnly"]' -s 'config.connectionPooling=["true"]' -s 'config.pagination=["true"]' --server http://127.0.0.1:8080/auth

         
echo " - declancher la synchronization de tous les utilisateurs"
# Use the storage provider’s id attribute to compose an endpoint URI, such as 
# user-storage/ID_OF_USER_STORAGE_INSTANCE/sync.
# Add the action=triggerFullSync query parameter and run the create command.
#$KCADM create user-storage/$PROVIDER_ID/sync?action=triggerFullSync



ROLE_MAPPER_NAME=PortailSmaclRoleMapper
parentId=$($KCADM get components -r $REALM_NAME --query name=$PROVIDER_NAME | /usr/bin/jq -er '.[].id')
echo " - creation du mapper [$ROLE_MAPPER_NAME] de type [role-ldap-mapper]"
    
           
PROVIDER_ID=$($KCADM get components -r $REALM_NAME -q name=$PROVIDER_NAME  --fields id --format csv --noquotes)
echo "PROVIDER_ID :$PROVIDER_ID"
echo "MAPPER_NAME :$ROLE_MAPPER_NAME"
echo "      - creation du mapper $ROLE_MAPPER_NAME"
   
$KCADM create components -r intranet -s name=$ROLE_MAPPER_NAME -s providerId=role-ldap-mapper -s providerType=org.keycloak.storage.ldap.mappers.LDAPStorageMapper -s parentId=$parentId -s 'config."roles.dn"=["ou=PortailSmacl,ou=ApplicationsTHEMIS,dc=smacl,dc=lan"]' -s 'config."mode"=["READ_ONLY"]' -s 'config."role.name.ldap.attribute"=["CN"]' -s 'config."role.object.classes"=["groupOfNames"]' -s 'config."membership.attribute.type"=["DN"]' -s 'config."user.roles.retrieve.strategy"=["LOAD_ROLES_BY_MEMBER_ATTRIBUTE"]' -s 'config."membership.ldap.attribute"=["member"]' -s 'config."membership.user.ldap.attribute"=["uid"]' -s 'config."memberof.ldap.attribute"=["memberOf"]' -s 'config."use.realm.roles.mapping"=["false"]' -s 'config."client.id"=["PortailSmacl"]' 
     


GROUP_MAPPER_NAME=groupe_mapper_1
echo " - creation mapper [$GROUP_MAPPER_NAME] de type [group-ldap-mapper]"
echo "   PARENT_ID : $parentId"
$KCADM create components -r intranet -s name=$GROUP_MAPPER_NAME -s providerId=group-ldap-mapper \
    -s providerType=org.keycloak.storage.ldap.mappers.LDAPStorageMapper -s parentId=$parentId \
    -s 'config."groups.dn"=["ou=Groups,${ldap_dn}"]' -s 'config."group.name.ldap.attribute"=["cn"]' \
    -s 'config."group.object.classes"=["posixGroup"]' -s 'config."preserve.group.inheritance"=["false"]' \
    -s 'config."membership.ldap.attribute"=["memberUid"]' -s 'config."membership.attribute.type"=["UID"]' \
    -s 'config."groups.ldap.filter"=[]' -s 'config.mode=["IMPORT"]' \
    -s 'config."user.roles.retrieve.strategy"=["LOAD_GROUPS_BY_MEMBER_ATTRIBUTE"]' \
    -s 'config."mapped.group.attributes"=[]' -s 'config."drop.non.existing.groups.during.sync"=["false"]'
    

    
#/opt/keycloak/bin/kcadm.sh create components -r $REALM_NAME -s name=hardcoded-ldap-role-mapper -s providerId=hardcoded-ldap-role-mapper -s providerType=org.keycloak.storage.ldap.mappers.LDAPStorageMapper -s parentId=$parentID -s 'config.role=["realm-management.create-client"]'
     