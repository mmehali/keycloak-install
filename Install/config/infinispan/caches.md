
Par défaut, Keycloak ne réplique PAS les caches tels que les sessions, authenticationSessions, offlineSessions, loginFailures et quelques autres, qui sont configurés en tant que caches distribués lors de l'utilisation d'une configuration en cluster. 

Les entrées ne sont pas répliquées sur chaque nœud, mais à la place, un ou plusieurs nœuds sont choisis comme propriétaire de ces données. Si un nœud n'est pas le propriétaire d'une entrée de cache spécifique, il interroge le cluster pour l'obtenir. Ce que cela signifie pour le Failover, c'est que si tous les nœuds qui possèdent un élément de données tombent en panne, ces données sont perdues à jamais. 

Par défaut, Keycloak ne spécifie qu'un seul propriétaire pour les données. Donc, si ce nœud tombe en panne, les données sont perdues. Cela signifie généralement que les utilisateurs seront déconnectés et devront se reconnecter.


### Spécifier les propriétaires de cache destribué
- CACHE_OWNERS_COUNT: spécifiez le nombre de propriétaires de cache distribué (la valeur par défaut est 
AuthenticationSessions ne sera pas répliqué en définissant CACHE_OWNERS_COUNT> 1 car cela n'est généralement pas requis.
Pour activer la réplication des AuthenticationSessions, utilisez également:

- CACHE_OWNERS_AUTH_SESSIONS_COUNT: spécifiez le nombre de répliques pour AuthenticationSessions