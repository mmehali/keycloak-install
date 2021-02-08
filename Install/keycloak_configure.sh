#!/usr/bin/env bash

#KEYCLOAK_HOME="/opt/keycloak"
#INSTALL_SRC=/opt/keycloak-install

#DRIVER_VERSION=42.2.5

source keycloak_variables.sh


POSTGRESQL_URL=https://repo1.maven.org/maven2/org/postgresql/postgresql/$DRIVER_VERSION/postgresql-$DRIVER_VERSION.jar


sudo mv ${KEYCLOAK_HOME}/bin/jboss-cli.xml ${KEYCLOAK_HOME}/bin/jboss-cli.original.xml
sudo cp ${INSTALL_SRC}/config/cli/jboss-cli.xml ${KEYCLOAK_HOME}/bin/jboss-cli.xml


echo "--------------------------------------------------------------------"
echo "Step 1 : Configuration keycloak : config log, proxy, hostname, etc "
echo "--------------------------------------------------------------------"
sudo ${KEYCLOAK_HOME}/bin/jboss-cli.sh --file=${INSTALL_SRC}/config/standalone-ha-config.cli --properties=env.properties

 
echo "--------------------------------------------------------------------"
echo "Step 2: Configuration Keycloak : Telechargement du driver postgresql HTTPS [KO]" 
echo "--------------------------------------------------------------------"
if [ -f "${INSTALL_SRC}/downloads/postgres-jdbc.jar" ];
   then
      echo "Installation postgresql depuis ${INSTALL_SRC}/downloads/postgresql-${DRIVER_VERSION}.jar..."
   else
      echo "Téléchargement de  postgresql-${DRIVER_VERSION}.jar ..."
      echo "depuis "-${POSTGRESQL_URL}" "
      sudo curl --url $POSTGRESQL_URL  -o ${INSTALL_SRC}/downloads/postgres-jdbc.jar
      if [ $? != 0 ];
      then
          echo "  - GRAVE: Téléchargement du driver Postgres impossible depuis ${POSTGRESQL_URL}"	
          exit 1
      fi
   echo "  - Telechargement du driver termine ..."
fi



echo "--------------------------------------------------------------------"
echo "Step 3: Installation du Module postgres                             "
echo "--------------------------------------------------------------------" 
sudo mkdir -p ${KEYCLOAK_HOME}/modules/system/layers/base/org/postgresql/jdbc/main/
sudo cp ${INSTALL_SRC}/downloads/postgres-jdbc.jar ${KEYCLOAK_HOME}/modules/system/layers/base/org/postgresql/jdbc/main/
sudo cp ${INSTALL_SRC}/config/postgres/module.xml ${KEYCLOAK_HOME}/modules/system/layers/base/org/postgresql/jdbc/main/
sudo chmod 777 ${KEYCLOAK_HOME}/modules/system/layers/base/org/postgresql/jdbc/main/

    
echo "-------------------------------------------------------------------------"
echo "Step 4 : configuration de datasource postgres                            "
echo "-------------------------------------------------------------------------"
sudo ${KEYCLOAK_HOME}/bin/jboss-cli.sh --file=${INSTALL_SRC}/config/postgres/standalone-ha-config.cli



echo "-------------------------------------------------------------------------"
echo "Step 5 : configuration du caches distribues (infinspan)                  "
echo "-------------------------------------------------------------------------"
sudo ${INSTALL_SRC}/config/infinispan/infinispan.sh


echo "-------------------------------------------------------------------------"
echo "Step 6 :  configuration des metriques                                    "
echo "-------------------------------------------------------------------------"
sudo ${INSTALL_SRC}/config/metrics/statistics.sh



echo "-------------------------------------------------------------------------"
echo "Step 7 : configuration du keystore x509                                  "
echo "-------------------------------------------------------------------------"    
sudo ${INSTALL_SRC}/config/keystore/x509_keystore.sh



echo "-------------------------------------------------------------------------"
echo "Step 8 : configuration du truststore x509      "
echo "-------------------------------------------------------------------------"    
sudo ${INSTALL_SRC}/config/truststore/x509_truststore.sh



echo "-------------------------------------------------------------------------"
echo "Step 9 : configuration des jgroups                                       "
echo "-------------------------------------------------------------------------"
sudo ${INSTALL_SRC}/config/jgroups/jgroups.sh
    
    
echo "-------------------------------------------------------------------------"
echo "Step 10 : Configuration keycloak : lancement de scripts spécifiques      "
echo "-------------------------------------------------------------------------"
sudo ${INSTALL_SRC}/config/startup_scripts/autorun.sh
    

echo "-------------------------------------------------------------------------"
echo "Step 11 : Configuration keycloak : configuration vault                   "
echo "-------------------------------------------------------------------------"
sudo ${INSTALL_SRC}/config/vault/vault.sh
    
exit 1

echo "-------------------------------------------------------------------"
echo "Step 11: ajouter un administateur keycloak                         "
echo "-------------------------------------------------------------------" 
sudo ${KEYCLOAK_HOME}/bin/add-user-keycloak.sh -u keycloak -p keycloak

echo "-------------------------------------------------------------------"
echo "Step 12: ajouter un administateur Wildfly                          "
echo "-------------------------------------------------------------------" 
sudo ${KEYCLOAK_HOME}/bin/add-user.sh -u wildfly -p wildfly 


sudo rm -rf ${KEYCLOAK_HOME}/standalone/configuration/standalone_xml_history
