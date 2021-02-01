
Par défaut en mode cluster, Keycloak ne réplique PAS les caches distribues tels que les **sessions**, **authenticationSessions**, **offlineSessions**, **loginFailures** et quelques autres.

Les entrées des ces caches ne sont pas répliquées sur chaque nœud, mais à la place, un ou plusieurs nœuds sont choisis comme propriétaire de ces données. Si un nœud n'est pas le propriétaire d'une entrée de cache spécifique, il interroge le cluster pour l'obtenir. Ce que cela signifie pour le Failover, c'est que si tous les nœuds qui possèdent un élément de données tombent en panne, ces données sont perdues à jamais. 

Si on ne spécifie qu'un seul propriétaire pour les données et que ce nœud tombe en panne, les données sont perdues. 
Cela signifie généralement que les utilisateurs seront déconnectés et devront se reconnecter.


### Spécifier les propriétaires de cache destribué
- **CACHE_OWNERS_COUNT**: spécifiez le nombre de propriétaires de cache distribué (valeur = nombre de noueds = 2)

```
echo "<distributed-cache name="sessions" owners="2"/>"
/subsystem=infinispan/cache-container=keycloak/distributed-cache=sessions: write-attribute(name=owners, value=2)

echo "<distributed-cache name="offlineSessions" owners="2"/>"
/subsystem=infinispan/cache-container=keycloak/distributed-cache=offlineSessions: write-attribute(name=owners, value=2)

echo "<distributed-cache name="loginFailures" owners="2"/>"
/subsystem=infinispan/cache-container=keycloak/distributed-cache=loginFailures: write-attribute(name=owners, value=2)

echo " <distributed-cache name="clientSessions" owners="2"/>"
/subsystem=infinispan/cache-container=keycloak/distributed-cache=clientSessions: write-attribute(name=owners, value=2)

echo " <distributed-cache name="offlineClientSessions" owners="2"/>"
/subsystem=infinispan/cache-container=keycloak/distributed-cache=offlineClientSessions: write-attribute(name=owners, value=2)
```

- **CACHE_OWNERS_AUTH_SESSIONS_COUNT**: Si on utilise les **sessions perssitantes**  au niveau du load balancer le cache de l'**authenticationSessions** n'a pas besoin d'être repliqué (valeur=1) 

```
echo " <distributed-cache name="actionTokens" owners="2">"
/subsystem=infinispan/cache-container=keycloak/distributed-cache=actionTokens: write-attribute(name=owners, value=2)
```