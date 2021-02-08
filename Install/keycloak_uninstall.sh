KEYCLOAK_HOME="/opt/keycloak"
INSTALL_SRC=/opt/keycloak-install
KEYCLOAK_VERSION=11.0.3

echo "step 1 : Supression du service keycloak "
sudo systemctl stop keycloak.service
sudo rm /etc/keycloak/keycloak.conf
sudo rm /etc/systemd/system/keycloak.service
sudo systemctl disable keyboard-setup.service

echo "step 2 : Supression du repertoire ${KEYCLOAK_HOME}"
sudo rm -r ${KEYCLOAK_HOME}

echo "step 3 : Supression du repertoire ${KEYCLOAK_HOME}-${KEYCLOAK_VERSION}"
sudo rm -r ${KEYCLOAK_HOME}-${KEYCLOAK_VERSION}

#echo "step 4 : Supression du repertoire ${INSTALL_SRC}"
#sudo rm -r ${INSTALL_SRC}
