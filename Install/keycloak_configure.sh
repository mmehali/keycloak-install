#!/usr/bin/env bash

INSTALL_SRC=/vagrant/Install


echo "--------------------------------------------------------------------"
echo "Step 1 : Configuration keycloak : config log, proxy, hostname, etc "
echo "--------------------------------------------------------------------"
sudo /opt/keycloak/bin/jboss-cli.sh --file=${INSTALL_SRC}/config/standalone-ha-config.cli --properties=env.properties

echo "--------------------------------------------------------------------"
echo "Step 2: Configuration Keycloak : Telechargement du driver postgresql HTTPS [KO]" 
echo "--------------------------------------------------------------------"
if [ -f "${INSTALL_SRC}/downloads/postgresql-${POSTGRES_VERSION}.jar" ];
   then
      echo "Installation postgresql depuis ${INSTALL_SRC}/downloads/postgresql-${POSTGRES_VERSION}.jar..."
   else
      echo "Téléchargement de  postgresql-${POSTGRES_VERSION}.jar ..."
      echo "depuis "-${POSTGRESQL_URL}" "
      wget -q -O ${INSTALL_SRC}/downloads/postgresql-${POSTGRES_VERSION}.jar  "${POSTGRES_URL}"
      #if [ $? != 0 ];
      #then
         # echo "GRAVE: Téléchargement du driver Postgres impossible depuis ${POSTGRESQL_URL}"	
         # exit 1
      #fi
   echo "Installation du driver postgres ..."
fi


#echo "--------------------------------------------------------------------"
#echo "Step 3: Configuration Keycloak : installation du Module postgres    "
#echo "--------------------------------------------------------------------" 
#sudo mkdir -p /opt/keycloak/modules/system/layers/base/org/postgresql/jdbc/main
#sudo cp ${INSTALL_SRC}/downloads/postgresql-${POSTGRES_VERSION}.jar /opt/keycloak/modules/system/layers/base/org/postgresql/jdbc/main/
#sudo cp ${INSTALL_SRC}/config/postgres/module.xml /opt/keycloak/modules/system/layers/base/org/postgresql/jdbc/main/

    
echo "-------------------------------------------------------------------------"
echo "Step 4 : Configuration keycloak : configuration de datasource postgres  "
echo "-------------------------------------------------------------------------"
#sudo /opt/keycloak/bin/jboss-cli.sh --file=${INSTALL_SRC}/config/postgres/standalone-ha-config.cli  --properties=env.properties


echo "-------------------------------------------------------------------------"
echo "Step 5 : Configuration keycloak : configuration du keystore x509         "
echo "-------------------------------------------------------------------------"    
sudo ${INSTALL_SRC}/config/keystore/x509_keystore.sh

echo "-------------------------------------------------------------------------"
echo "Step 6 : Configuration keycloak : configuration du truststore) x509      "
echo "-------------------------------------------------------------------------"    
sudo ${INSTALL_SRC}/config/truststore/x509_truststore.sh


echo "-------------------------------------------------------------------------"
echo "Step 7 : Configuration keycloak : configuration des jgroups             "
echo "-------------------------------------------------------------------------"
sudo ${INSTALL_SRC}/config/jgroups/jgroups.sh
    
echo "-------------------------------------------------------------------------"
echo "Step 8 : Configuration keycloak : configuration du cache (infinspan)    "
echo "-------------------------------------------------------------------------"
sudo ${INSTALL_SRC}/config/infinispan/infinispan.sh
    
echo "-------------------------------------------------------------------------"
echo "Step 9 : Configuration keycloak : configuration des statistiques        "
echo "-------------------------------------------------------------------------"
sudo ${INSTALL_SRC}/config/metrics/statistics.sh
    
echo "-------------------------------------------------------------------------"
echo "Step 10 : Configuration keycloak : configuration vault                   "
echo "-------------------------------------------------------------------------"
sudo ${INSTALL_SRC}/config/vault/vault.sh
    
echo "-------------------------------------------------------------------------"
echo "Step 11 : Configuration keycloak : lancement de scripts spécifiques      "
echo "-------------------------------------------------------------------------"
sudo ${INSTALL_SRC}/autorun.sh
    
    
echo "-------------------------------------------------------------------"
echo "Step 11: ajouter un administateur keycloak                         "
echo "-------------------------------------------------------------------" 
sudo /opt/keycloak/bin/add-user-keycloak.sh -u keycloak -p keycloak

echo "-------------------------------------------------------------------"
echo "Step 12: ajouter un administateur Wildfly                          "
echo "-------------------------------------------------------------------" 
sudo /opt/keycloak/bin/add-user.sh -u wildfly -p wildfly 


sudo rm -rf /opt/keycloak/standalone/configuration/standalone_xml_history
