Keycloak peut collecter des statistiques pour divers sous-systèmes qui seront 
ensuite disponibles dans la console de gestion et le endpoint http:/localhost:9990/metrics. 
Vous pouvez l'activer avec les variables d'environnement KEYCLOAK_STATISTICS qui 
prennent une liste de statistiques pour activer:

- db pour le sous-système datasource
- http pour le sous-système de undertow
- jgroups pour le sous-système jgroups

Par exemple, KEYCLOAK_STATISTICS=db,http activera les statistiques pour 
les sources de données et le sous-système undetow.

La valeur spéciale all active toutes les statistiques.

Une fois activée, vous devriez voir les valeurs de métriques changer sur le endpoint /metrics

- **endpoint health check** :http:/localhost:9990/health

