### Exécution de scripts personnalisés au démarrage


Pour exécuter des scripts personnalisés au démarrage, placez un fichier dans le répertoire /opt/jboss/startup-scripts.

Deux types de scripts sont pris en charge:

- Scripts WildFly .cli. Dans la plupart des cas, les scripts doivent fonctionner en mode hors ligne (
en utilisant les instructions du serveur incorporé). 
Il convient également de mentionner que par défaut, keycloak utilise la configuration standalone-ha.xml 
(sauf si une autre configuration de serveur est spécifiée).

- Tout script exécutable (chmod + x)