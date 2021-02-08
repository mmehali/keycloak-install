#!/bin/bash
 

KEYCLOAK_HOME=/opt/keycloak
INSTALL_SRC=/opt/keycloak-install


KEYSTORES_DIR=${KEYCLOAK_HOME}/standalone/configuration/keystores

  
  echo " a - Copier la clé prive  tls.key et le certificat tls.crt dans /etc/x509/https "
  if [ ! -d "/etc/x509/https" ]; then
    mkdir -p /etc/x509/https
  fi
  sudo cp ${INSTALL_SRC}/certificats/tls.key /etc/x509/https/
  sudo cp ${INSTALL_SRC}/certificats/tls.crt /etc/x509/https/
  
   
   
  echo " b - Creation du keystore ${KEYSTORES_DIR}/https-keystore.pk12     "  
  if [ ! -d "${KEYSTORES_DIR}" ]; then
     mkdir -p "${KEYSTORES_DIR}"
  fi


  echo " b1 - auto-generer un keystore https servant des certificats x509"
  if [ -f "/etc/x509/https/tls.key" ] && [ -f "/etc/x509/https/tls.crt" ]; then

     echo "  b1.1 -- generer et encoder un mot de passe de 32 caracteres"
     PASSWORD=$(openssl rand -base64 32)
     PASSWORD=changeit
     echo "  b1.2 -- creation du keysrore ${KEYSTORES_DIR}/https-keystore.pk12"
     echo "  sudo openssl pkcs12 -export    "
     echo "       -name keycloak-https-key "      
     echo "       -inkey /etc/x509/https/tls.key "
     echo "       -in /etc/x509/https/tls.crt    "
     echo "       -out ${KEYSTORES_DIR}/https-keystore.pk12 " 
     echo "       -password pass:${PASSWORD}"
     sudo openssl pkcs12 -export -name keycloak-https-key -inkey /etc/x509/https/tls.key -in /etc/x509/https/tls.crt -out ${KEYSTORES_DIR}/https-keystore.pk12 -password pass:${PASSWORD} 

     echo "  b1.3 -- importer le keystore java dans ${KEYSTORES_DIR}/https-keystore.jks"
     echo "  sudo keytool -importkeystore  -noprompt"
     echo "             -srcalias keycloak-https-key"
     echo "             -destalias keycloak-https-key"
     echo "             -srckeystore ${KEYSTORES_DIR}/https-keystore.pk12"
     echo "             -srcstoretype pkcs12"
     echo "             -destkeystore ${KEYSTORES_DIR}/https-keystore.jks" 
     echo "             -storepass ${PASSWORD}"
     echo "             -srcstorepass ${PASSWORD}"
     sudo keytool -importkeystore -noprompt -srcalias keycloak-https-key -destalias keycloak-https-key -srckeystore ${KEYSTORES_DIR}/https-keystore.pk12 -srcstoretype pkcs12 -destkeystore ${KEYSTORES_DIR}/https-keystore.jks -storepass ${PASSWORD} -srcstorepass ${PASSWORD}

     if [ -f "${KEYSTORES_DIR}/https-keystore.jks" ]; then
        echo "  [OK] keystore https cree avec succes : ${KEYSTORES_DIR}/https-keystore.jks"
     else
	    echo "  [KO] Impossible de creer le keystore https, verifier les permissions: ${KEYSTORES_DIR}/https-keystore.jks"
     fi
     
     echo ""
     echo "  b1.4 -- ajouter les parametres du keystore ci-dessous dans ${KEYCLOAK_HOME}/bin/.jbossclirc"
     echo "set keycloak_tls_keystore_password=${PASSWORD}" >> ${KEYCLOAK_HOME}/bin/.jbossclirc
     echo "set keycloak_tls_keystore_file=${KEYSTORES_DIR}/https-keystore.jks" >> ${KEYCLOAK_HOME}/bin/.jbossclirc
     #echo "set configuration_file=standalone.xml" >> ${KEYCLOAK_HOME}/bin/.jbossclirc
     #sudo ${KEYCLOAK_HOME}/bin/jboss-cli.sh --file=${INSTALL_SRC}/config/keystore/x509-keystore.cli
     #sed -i '$ d' ${KEYCLOAK_HOME}/bin/.jbossclirc
     echo "set configuration_file=standalone-ha.xml" >> ${KEYCLOAK_HOME}/bin/.jbossclirc
     #sudo more ${KEYCLOAK_HOME}/bin/.jbossclirc
     echo "  b1.5 -- configuration xml du keystore "
     ${KEYCLOAK_HOME}/bin/jboss-cli.sh --file=${INSTALL_SRC}/config/keystore/x509-keystore.cli 
     sed -i '$ d' ${KEYCLOAK_HOME}/bin/.jbossclirc  
  fi

