#!/usr/bin/env bash
source keycloak_variables.sh

KEYCLOAK_URL=http://downloads.jboss.org/keycloak/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.tar.gz



echo "===================================================================="
echo "                      INSTALLATION KEYCLOAK                         "
echo "===================================================================="
sudo mkdir -p ${INSTALL_SRC}
sudo cp -r * ${INSTALL_SRC}
 

echo "--------------------------------------------------------------------"
echo " Etape 0: Mise a jour des packages                                  "
echo "--------------------------------------------------------------------"
#sudo yum check-update 
#sudo yum clean all -y
#sudo yum update -y

sudo yum install -y wget
sudo yum install -y nano
sudo yum install -y jq


echo "--------------------------------------------------------------------"
echo "Step 1: Installation JDK                                            "
echo "--------------------------------------------------------------------"
sudo yum install -y java-1.8.0-openjdk
#sudo yum install -y java-1.8.0-openjdk-devel -y


echo "--------------------------------------------------------------------"
echo "Step 2: Creation d'un user/group keycloak:keycloak                  "
echo "--------------------------------------------------------------------"
#sudo groupadd -r keycloak                   #pb
#sudo useradd  -r -g keycloak -d ${KEYCLOAK_HOME} -s /sbin/nologin keycloak #pb


echo "--------------------------------------------------------------------"
echo "Step 3: Téléchargement de keycloak                                  "
echo "--------------------------------------------------------------------"
if [ -f "${INSTALL_SRC}/downloads/keycloak-${KEYCLOAK_VERSION}.tar.gz" ];
then
    echo "Installation Keycloak depuis ${INSTALL_SRC}/downloads/keycloak-${KEYCLOAK_VERSION} ..."
else
    echo "Téléchargement de  keycloak-${KEYCLOAK_VERSION} ..."
    echo "depuis "${KEYCLOAK_URL}" "
    sudo mkdir -p ${INSTALL_SRC}/downloads
    sudo wget -q -O ${INSTALL_SRC}/downloads/keycloak-${KEYCLOAK_VERSION}.tar.gz "${KEYCLOAK_URL}" 
    if [ $? != 0 ];
    then
        echo "GRAVE: Téléchargement impossible depuis ${KEYCLOAK_URL}"	
        exit 1
    fi
    echo "Telechargement termine ..."
fi


echo "--------------------------------------------------------------------"
echo "Step 4: Extraction keycloak-${KEYCLOAK_VERSION}.tar.gz dans /opt    "
echo "--------------------------------------------------------------------" 
sudo tar xfz ${INSTALL_SRC}/downloads/keycloak-${KEYCLOAK_VERSION}.tar.gz -C /opt


echo "--------------------------------------------------------------------"
echo "Step 5: Creation d'un lien symbolique ${KEYCLOAK_HOME} pointant sur "
echo "        le rep d'install ${KEYCLOAK_HOME}-${KEYCLOAK_VERSION}       "
echo "--------------------------------------------------------------------"
sudo ln -sfn ${KEYCLOAK_HOME}-${KEYCLOAK_VERSION} ${KEYCLOAK_HOME}



echo "--------------------------------------------------------------------"
echo "Step 6: Permettre au user keycloak:keycloak d'executer keycloak [KO] "
echo "--------------------------------------------------------------------"
#sudo chown -R keycloak:keycloak ${KEYCLOAK_HOME}   #pb


#echo "--------------------------------------------------------------------"
#echo "Step 7: Limiter l'acces au repertoire standalone [KO]               "
#echo "--------------------------------------------------------------------" 
#sudo -u keycloak chmod 700 ${KEYCLOAK_HOME}/standalone   #pb
sudo chmod 777 ${KEYCLOAK_HOME}/standalone

echo "--------------------------------------------------------------------"
echo "Step 8 : Backup : copier le fichier standalone-ha.xml dans ${INSTALL_SRC}/backup/standalone-ha.orginal.xml   "
echo "--------------------------------------------------------------------"
sudo mkdir -p ${INSTALL_SRC}/backup
sudo cp ${KEYCLOAK_HOME}/standalone/configuration/standalone-ha.xml ${INSTALL_SRC}/backup/standalone-ha.orginal.xml


#sudo mv ${KEYCLOAK_HOME}/bin/jboss-cli.xml ${KEYCLOAK_HOME}/bin/jboss-cli.original.xml
#sudo cp ${INSTALL_SRC}/config/cli/jboss-cli.xml ${KEYCLOAK_HOME}/bin/jboss-cli.xml

#echo "====================================================================="
#echo "                       CONFIGURATION KEYCLOAK                        "
#echo "====================================================================="
#configured_file="${KEYCLOAK_HOME}/configured"
#if [ ! -e "$configured_file" ]; then
#    touch "$configured_file"
#    sudo ${INSTALL_SRC}/keycloak_configure.sh
#fi

#echo "--------------------------------------------------------------------"
#echo "Step 10 : Backup : copier le fichier standalone-ha.xml dans backup  "
#echo "--------------------------------------------------------------------"
#sudo cp ${KEYCLOAK_HOME}/standalone/configuration/standalone-ha.xml ${INSTALL_SRC}/backup/standalone-ha.actual.xml


#echo "===================================================================="
#echo "                      BOOTSTRAP KEYCLOAK                            "
#echo "===================================================================="
#sudo ${INSTALL_SRC}/keycloak_startup.sh


#echo "===================================================================="
#echo "                      Configure REALMS                              "
#echo "===================================================================="
#sudo ${INSTALL_SRC}/../configure/keycloak_configure.sh

