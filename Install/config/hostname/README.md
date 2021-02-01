## Hostname et nom de domaine public
Keycloak utilise un nom d'hôte public pour un certain nombre de choses. Par exemple, dans :
 - Les champs issuer  du token(l'émetteur du jeton) et 
 - Les URL envoyées dans les e-mails de réinitialisation de mot de passe.
 
Le **SPI hostname** permet de configurer le nom du hôte. Le provider par défaut permet de définir une 
URL fixe pour les requêtes frontales, tout en permettant aux requêtes backend d'être basées sur l'URI 
de la requête.

Le provider Hostname de keycloak par défaut utilise le **frontendUrl** configurée comme URL de base 
pour les requêtes frontales (requêtes via le navigateur) et utilise l'URL de la requête comme base 
pour les requêtes backend (requêtes directes des clients).

Les requêtes frontales ne doivent pas nécessairement avoir le même chemin de contexte que le serveur Keycloak. 
Cela signifie que vous pouvez exposer Keycloak sur, par exemple, https://auth.example.org ou 
https://example.org/keycloak alors qu'en interne son URL pourrait être https://10.0.0.10:8080/auth.
Cela permet  aux navigateurs d'envoyer des requêtes à Keycloak via le nom de domaine public, tandis 
que les clients internes peuvent utiliser un nom de domaine interne ou une adresse IP.

Cela se reflète dans le point de terminaison OpenID Connect Discovery ci-dessous :
```
https://host_et_port_du_proxy_ou_du_LB/auth/realms/master/.well-known/openid-configuration
```
Par exemple, où le endpoint d'autorisation utilise l'URL frontend, tandis que token_endpoint utilise 
l'URL principale. Comme note ici, un client public par exemple contacterait Keycloak via le endpoint 
public, ce qui veut dire que la base de l’url du endpoint autorisation et du endpoint token serait la même.

Pour définir le frontendUrl pour Keycloak, vous pouvez soit 
-	passer -Dkeycloak.frontendUrl = https://auth.example.org au démarrage, 
-	soit le configurer dans standalone-ha.xml de la manière suivante :

```
   <spi name="hostname">
    <default-provider>default</default-provider>
    <provider name="default" enabled="true">
        <properties>
            <property name="frontendUrl" 
               value="${keycloak.frontendUrl:https://auth.smacl.com}"/>
            <property name="forceBackendUrlToFrontendUrl" value="false"/>
        </properties>
    </provider>
</spi>
```

Pour mettre à jour frontendUrl avec jboss-cli, utilisez la commande suivante:
```
/subsystem=keycloak-server/spi=hostname/provider=default:write-attribute(
               name=properties.frontendUrl,
               value="${keycloak.frontendUrl:https://auth.example.com}")
```
Si vous souhaitez que toutes les requêtes passent par le nom de domaine public, vous 
pouvez également forcer les requêtes backend à utiliser l'URL frontend en définissant 
**forceBackendUrlToFrontendUrl** sur true.

Si vous ne souhaitez pas exposer les endpoints et la console d'administration sur le domaine public, 
utilisez la propriété **adminUrl** pour définir une URL fixe pour la console d'administration, 
qui est différente de **frontendUrl**. Il est également nécessaire de bloquer l'accès à 
**/auth/admin** en externe, pour plus de détails sur la façon de procéder, 
reportez-vous au Guide d'administration du serveur.





