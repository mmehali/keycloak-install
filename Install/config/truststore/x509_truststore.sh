#!/bin/bash
 
KEYCLOAK_HOME=/opt/keycloak
INSTALL_SRC=/opt/keycloak-install


KEYSTORES_DIR=${KEYCLOAK_HOME}/standalone/configuration/keystores
echo "-----------------------------------------------------------------"
echo "   Configuration du truststore                                   "
echo "-----------------------------------------------------------------"

echo " a - autogeneration dutruststore : ${KEYSTORES_DIR}/truststore.jks"

X509_CA_BUNDLE="${INSTALL_SRC}/config/truststore/ca_bundle/tls.crt"
if [ -n ${X509_CA_BUNDLE} ]; then
 
   echo "  a.1 - ceneration d'un mot de passe pour le truststore"
   PASSWORD=$(openssl rand -base64 32 2>/dev/null)
   PASSWORD=changeit

   # On utlise le cat, afin de specifier plusieurs CA Bundles separes par des espaces
   echo "  a.2 - copier ${X509_CA_BUNDLE} dans temp_ca.crt"
   cat ${X509_CA_BUNDLE} > temp_ca.crt
 
   echo "  a.3 - extraire les certificats de temp_ca.crt"
   echo "  csplit -s -z -f crt- temp_ca.crt /-----BEGIN CERTIFICATE-----/ '{*}'"
   csplit -s -z -f crt- temp_ca.crt "/-----BEGIN CERTIFICATE-----/" '{*}'
   
   
   for CERT_FILE in crt-*; do
     echo  "  a.4 - importer le certificat: $CERT_FILE  dans le truststore ${KEYSTORES_DIR}/truststore.jks"
     echo "   sudo keytool -import -noprompt "
     echo "                -keystore ${KEYSTORES_DIR}/truststore.jks" 
     echo "                -file ${CERT_FILE}" 
     echo "                -storepass ${PASSWORD}"
     echo "                -alias service-${CERT_FILE}"
     sudo keytool -import -noprompt -keystore ${KEYSTORES_DIR}/truststore.jks -file ${CERT_FILE} -storepass ${PASSWORD} -alias service-${CERT_FILE} >& /dev/null
   done
   
   if [ -f ${KEYSTORES_DIR}/truststore.jks ]; then
     echo "  [OK] - Truststore keycloak cree avec succes : ${KEYSTORES_DIR}/truststore.jks"
   else
     echo "  [KO] - Probleme lors de la creation du Truststore keycloak : ${KEYSTORES_DIR}/truststore.jks"
   fi
   
   echo "-----------------------------------------------------------------------------"
   echo " b - importer les certificat CA existantes dans le truststore                    "
   echo " /etc/pki/ca-trust/extracted/java/cacerts => ${KEYCLOAK_HOME}/standalone/configuration/keystores/truststore.jks"
   echo "-----------------------------------------------------------------------------" 

   SYSTEM_CACERTS=$(readlink -e $(dirname $(readlink -e $(which keytool)))/../lib/security/cacerts)
   if sudo keytool -v -list -keystore ${SYSTEM_CACERTS} -storepass changeit >/dev/null ; then
      echo "  b.1 - Importer les certificates de Java CA certificate bundle dans le truststore Keycloak"
      echo "  sudo keytool -importkeystore -noprompt"
      echo "               -srckeystore ${SYSTEM_CACERTS} "
      echo "               -destkeystore ${KEYSTORES_DIR}/truststore.jks" 
      echo "               -srcstoretype jks -deststoretype jks"
      echo "               -storepass ${PASSWORD}"
      echo "               -srcstorepass changeit"
      sudo keytool -importkeystore -noprompt -srckeystore ${SYSTEM_CACERTS} -destkeystore ${KEYSTORES_DIR}/truststore.jks -srcstoretype jks -deststoretype jks -storepass ${PASSWORD} -srcstorepass "changeit" >& /dev/null
   
      if [ "$?" -eq "0" ]; then
        echo "  [OK] - certificates de "system Java CA certificate bundle" importees dans truststore KC : ${KEYSTORES_DIR}/truststore.jks"
      else
       echo "   [KO] - probleme lors de l'import des certeficats du "system Java CA certificate bundle" dans KC !"
      fi
   fi
   
   echo " c - ajouter les parametres suivants au fichier ${KEYCLOAK_HOME}/bin/.jbossclirc"
   echo "set keycloak_tls_truststore_password=${PASSWORD}" >> ${KEYCLOAK_HOME}/bin/.jbossclirc
   echo "set keycloak_tls_truststore_file=${KEYSTORES_DIR}/truststore.jks" >> ${KEYCLOAK_HOME}/bin/.jbossclirc
   echo "set configuration_file=standalone-ha.xml" >> ${KEYCLOAK_HOME}/bin/.jbossclirc
   #sudo more ${KEYCLOAK_HOME}/bin/.jbossclirc
   echo " d - configuration xml"
   sudo ${KEYCLOAK_HOME}/bin/jboss-cli.sh --file=${INSTALL_SRC}/config/truststore/x509-truststore.cli 
   sed -i '$ d' ${KEYCLOAK_HOME}/bin/.jbossclirc
fi

