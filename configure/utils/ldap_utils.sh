#!/usr/bin/env bash

/opt/keycloak/bin/kcadm.sh create components -r intranet -s name=kerberos-ldap-provider -s providerId=ldap -s providerType=org.keycloak.storage.UserStorageProvider -s parentId=3d9c572b-8f33-483f-98a6-8bb421667867  -s 'config.priority=["1"]' -s 'config.fullSyncPeriod=["-1"]' -s 'config.changedSyncPeriod=["-1"]' -s 'config.cachePolicy=["DEFAULT"]' -s config.evictionDay=[] -s config.evictionHour=[] -s config.evictionMinute=[] -s config.maxLifespan=[] -s 'config.batchSizeForSync=["1000"]' -s 'config.editMode=["WRITABLE"]' -s 'config.syncRegistrations=["false"]' -s 'config.vendor=["other"]' -s 'config.usernameLDAPAttribute=["uid"]' -s 'config.rdnLDAPAttribute=["uid"]' -s 'config.uuidLDAPAttribute=["entryUUID"]' -s 'config.userObjectClasses=["inetOrgPerson, organizationalPerson"]' -s 'config.connectionUrl=["ldap://localhost:10389"]'  -s 'config.usersDn=["ou=People,dc=keycloak,dc=org"]' -s 'config.authType=["simple"]' -s 'config.bindDn=["uid=admin,ou=system"]' -s 'config.bindCredential=["secret"]' -s 'config.searchScope=["1"]' -s 'config.useTruststoreSpi=["ldapsOnly"]' -s 'config.connectionPooling=["true"]' -s 'config.pagination=["true"]' -s 'config.allowKerberosAuthentication=["true"]' -s 'config.serverPrincipal=["HTTP/localhost@KEYCLOAK.ORG"]' -s 'config.keyTab=["http.keytab"]' -s 'config.kerberosRealm=["KEYCLOAK.ORG"]' -s 'config.debug=["true"]' -s 'config.useKerberosForPasswordAuthentication=["true"]'


createLdapProvider(
kcadm.sh create components \
      -r demorealm 
      -s name=kerberos-ldap-provider 
      -s providerId=ldap 
      -s providerType=org.keycloak.storage.UserStorageProvider 
      -s parentId=3d9c572b-8f33-483f-98a6-8bb421667867  
      -s 'config.priority=["1"]' 
      -s 'config.fullSyncPeriod=["-1"]' 
      -s 'config.changedSyncPeriod=["-1"]' 
      -s 'config.cachePolicy=["DEFAULT"]' 
      -s config.evictionDay=[] -s 
      config.evictionHour=[] 
      -s config.evictionMinute=[] 
      -s config.maxLifespan=[] -s 
      'config.batchSizeForSync=["1000"]' 
      -s 'config.editMode=["WRITABLE"]' 
      -s 'config.syncRegistrations=["false"]' 
      -s 'config.vendor=["other"]' 
      -s 'config.usernameLDAPAttribute=["uid"]' 
      -s 'config.rdnLDAPAttribute=["uid"]' 
      -s 'config.uuidLDAPAttribute=["entryUUID"]' 
      -s 'config.userObjectClasses=["inetOrgPerson, organizationalPerson"]' 
      -s 'config.connectionUrl=["ldap://localhost:10389"]'  
      -s 'config.usersDn=["ou=People,dc=keycloak,dc=org"]' 
      -s 'config.authType=["simple"]'
      -s 'config.bindDn=["uid=admin,ou=system"]' 
      -s 'config.bindCredential=["secret"]' 
      -s 'config.searchScope=["1"]' 
      -s 'config.useTruststoreSpi=["ldapsOnly"]' 
      -s 'config.connectionPooling=["true"]' 
      -s 'config.pagination=["true"]' 
      -s 'config.allowKerberosAuthentication=["true"]' 
      -s 'config.serverPrincipal=["HTTP/localhost@KEYCLOAK.ORG"]' 
      -s 'config.keyTab=["http.keytab"]' 
      -s 'config.kerberosRealm=["KEYCLOAK.ORG"]' 
      -s 'config.debug=["true"]' 
      -s 'config.useKerberosForPasswordAuthentication=["true"]'
}