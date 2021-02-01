### Préparation du script de lancement du service keycloak

- Copiez le script de lancement de Keycloak launch.sh dans le répertoire /opt/keycloak/bin/

```
sudo cp ${INSTALL_SRC}/service/keycloak.conf /etc/keycloak/
```

Le fichier **launch.sh** est une copie modifiée du fichier **lauch.sh** qui se trouve dans la distribution keycloak 
sous le répertoire **/opt/keycloak/docs/contrib/scripts/systemd**

```
sudo cp ${INSTALL_SRC}/service/launch.sh /opt/keycloak/bin/
```
-	Nous devons faire de l’utilisateur keycloak propriétaire de ce script afin qu'il puisse l'exécuter:
```
sudo chmod +x /opt/keycloak/bin/launch.sh
#sudo chown keycloak: /opt/keycloak/bin/launch.sh
```

### Configuration du fichier de définition du service
-	copiez le fichier de définition de service keycloak.service dans le répertoire /etc/systemd/system/ 
```
sudo cp ${INSTALL_SRC}/service/keycloak.service /etc/systemd/system/
```

Le fichier **keycloak.service** est une copie modifiée du fichier **wildfly.service** qui se trouve dans la distribution 
keycloak sous le répertoire **/opt/keycloak/docs/contrib/scripts/systemd**

### Activation et démarrage du service
- Rechargez la configuration du gestionnaire systemd et activer le service keycloak au démarrage du système.

```
sudo systemctl daemon-reload
```
- Démarrez et activé le service système keycloak:

```
 sudo systemctl start keycloak
 sudo systemctl enable keycloak
```

- Une fois le service démarré, vous pouvez vérifier son état en exécutant la commande :

```
  $ sudo systemctl status keycloak
```

-	Vous pouvez également suivre les journaux du serveur Keycloak avec la commande :
```
 $ sudo tail -f /opt/keycloak/standalone/log/server.log
```

### Test 
Accédez maintenant au serveur Keycloak à l'adresse:
```
http://<ip>:8080/auth/
```
