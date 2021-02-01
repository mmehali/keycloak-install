## Clustering
Le remplacement des protocoles de découverte (**discovery protocols**) par défaut (PING pour la pile UDP et MPING pour celui TCP) peut être réalisé en définissant des variables d'environnement supplémentaires:

- JGROUPS_DISCOVERY_PROTOCOL - nom du protocole de découverte, par ex. dns.DNS_PING
- JGROUPS_DISCOVERY_PROPERTIES - un paramètre facultatif avec les propriétés du protocole de découverte au 
  format suivant: PROP1 = FOO, PROP2 = BAR
- JGROUPS_DISCOVERY_PROPERTIES_DIRECT - un paramètre facultatif avec les propriétés du protocole de 
  découverte au format CLI jboss: {PROP1 => FOO, PROP2 => BAR}
- JGROUPS_TRANSPORT_STACK - un nom facultatif de la pile de transport pour utiliser udp ou tcp sont 
  des valeurs possibles. Par défaut: tcp

**Avertissement**: C'est une erreur de définir à la fois JGROUPS_DISCOVERY_PROPERTIES et JGROUPS_DISCOVERY_PROPERTIES_DIRECT. Pas plus d'un d'entre eux ne peut être défini.

Le script d'amorçage détectera les variables et ajustera la configuration standalone-ha.xml 
en fonction d'elles.

###Exemple PING
  Le protocole de découverte PING est utilisé par défaut dans la pile udp (qui est utilisé par défaut dans   standalone-ha.xml). Étant donné que l'image Keycloak s'exécute par défaut en mode cluster, 
  il vous suffit de l'exécuter:

  Si vous en avez deux instances localement, vous remarquerez qu'elles forment un cluster.