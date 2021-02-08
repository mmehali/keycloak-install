if [ -f "/etc/systemd/system/keycloak.service" ];
then
   sudo systemctl stop keycloak.service
   sudo rm /etc/keycloak/keycloak.conf
   sudo rm /etc/systemd/system/keycloak.service
   sudo systemctl disable keyboard-setup.service   
else
    echo "le service keycloak est deja desinstalle ..."
fi

