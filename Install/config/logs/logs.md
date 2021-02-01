### Spécifiez le niveau de journalisation des logs
Deux variables d'environnement sont disponibles pour contrôler le niveau de journalisation de Keycloak:

- KEYCLOAK_LOGLEVEL: spécifiez le niveau de journalisation pour Keycloak (facultatif, la valeur par défaut est INFO)
- ROOT_LOGLEVEL: spécifiez le niveau de journal pour le conteneur sous-jacent (facultatif, la valeur par défaut est INFO)

Les niveaux de journal pris en charge sont ALL, DEBUG, ERROR, FATAL, INFO, OFF, TRACE et WARN.

Le niveau de journalisation peut également être modifié au moment de l'exécution:
```
./keycloak/bin/jboss-cli.sh --connect --command='/subsystem=logging/console-handler=CONSOLE:change-log-level(level=DEBUG)'
./keycloak/bin/jboss-cli.sh --connect --command='/subsystem=logging/root-logger=ROOT:change-root-log-level(level=DEBUG)'
./keycloak/bin/jboss-cli.sh --connect --command='/subsystem=logging/logger=org.keycloak:write-attribute(name=level,value=DEBUG)'
```