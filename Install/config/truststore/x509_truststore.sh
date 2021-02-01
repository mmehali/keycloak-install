#!/bin/bash
 
INSTALL_SRC=/vagrant/Install
KEYSTORES_DIR=/opt/keycloak/standalone/configuration/keystores
echo "-----------------------------------------------------------------"
echo "   Configuration du truststore                                   "
echo "-----------------------------------------------------------------"

# Auto-generate the Keycloak truststore if X509_CA_BUNDLE was provided
echo "- Configuration du truststore : ${KEYSTORES_DIR}/truststore.jks"

X509_CA_BUNDLE="/vagrant/Install/ca_bundle/tls.crt"
# X509_CA_BUNDLE=/ca.crt /ca2.crt
if [ -n ${X509_CA_BUNDLE} ]; then
   #pushd /tmp >& /dev/null
   echo "-------------------------------------------------------"
   echo "     creation du Truststore Keykloak                   "
   echo "-------------------------------------------------------"
   
   echo "- Generation d'un mot de passe pour le truststore"
   PASSWORD=$(openssl rand -base64 32 2>/dev/null)
   PASSWORD=changeit

   # On utlise le cat, afin de sp  cifier plusieurs CA Bundles s  par  s par des espaces
   echo "- Copier ${X509_CA_BUNDLE} dans temporary_ca.crt"
   cat ${X509_CA_BUNDLE} > temporary_ca.crt
 
   echo "- Extraire les certificats : csplit -s -z -f crt- temporary_ca.crt /-----BEGIN CERTIFICATE-----/ '{*}'"
   csplit -s -z -f crt- temporary_ca.crt "/-----BEGIN CERTIFICATE-----/" '{*}'
   
   
   for CERT_FILE in crt-*; do
     echo  "Pour chaque certificat: $CERT_FILE"
     echo "sudo keytool -import -noprompt -keystore ${KEYSTORES_DIR}/truststore.jks -file ${CERT_FILE} -storepass ${PASSWORD} -alias service-${CERT_FILE}"
     sudo keytool -import -noprompt -keystore ${KEYSTORES_DIR}/truststore.jks -file ${CERT_FILE} -storepass ${PASSWORD} -alias service-${CERT_FILE}
   done
   
   if [ -f ${KEYSTORES_DIR}/truststore.jks ]; then
     echo "- Truststore keycloak cree avec succes : ${KEYSTORES_DIR}/truststore.jks"
   else
     echo "- Probleme lors de la creation du Truststore keycloak : ${KEYSTORES_DIR}/truststore.jks"
   fi
   
   echo "-----------------------------------------------------------------------------"
   echo " Import existing system CA certificates into the newly generated truststore  "
   echo " keystore /etc/pki/ca-trust/extracted/java/cacerts to /opt/keycloak/standalone/configuration/keystores/truststore.jks"
   echo "-----------------------------------------------------------------------------" 

   SYSTEM_CACERTS=$(readlink -e $(dirname $(readlink -e $(which keytool)))/../lib/security/cacerts)
   if sudo keytool -v -list -keystore ${SYSTEM_CACERTS} -storepass changeit ; then
      echo "- Importer les certificates de Java CA certificate bundle dans le truststore Keycloak"
      echo "sudo keytool -importkeystore -noprompt -srckeystore ${SYSTEM_CACERTS} -destkeystore ${KEYSTORES_DIR}/truststore.jks -srcstoretype jks -deststoretype jks -storepass ${PASSWORD} -srcstorepass changeit"
            sudo keytool -importkeystore -noprompt -srckeystore ${SYSTEM_CACERTS} -destkeystore ${KEYSTORES_DIR}/truststore.jks -srcstoretype jks -deststoretype jks -storepass ${PASSWORD} -srcstorepass changeit
   
      if [ "$?" -eq "0" ]; then
        echo "Successfully imported certificates from system Java CA certificate bundle into Keycloak truststore at: ${KEYSTORES_DIR}/truststore.jks"
      else
       echo "Failed to import certificates from system Java CA certificate bundle into Keycloak truststore!"
      fi
   fi
   
   echo "- ajouter les parametres suivant aux fichier /opt/keycloak/bin/.jbossclirc"
   echo "set keycloak_tls_truststore_password=${PASSWORD}" >> /opt/keycloak/bin/.jbossclirc
   echo "set keycloak_tls_truststore_file=${KEYSTORES_DIR}/truststore.jks" >> /opt/keycloak/bin/.jbossclirc
   echo "set configuration_file=standalone-ha.xml" >> /opt/keycloak/bin/.jbossclirc
   sudo more /opt/keycloak/bin/.jbossclirc
   echo "- configuration xml"
   sudo /opt/keycloak/bin/jboss-cli.sh --file=${INSTALL_SRC}/config/truststore/x509-truststore.cli
   sed -i '$ d' /opt/keycloak/bin/.jbossclirc

   #popd >& /dev/null
fi

