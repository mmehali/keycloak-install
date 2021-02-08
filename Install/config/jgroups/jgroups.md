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
   
###JDBC_PING
```
 <subsystem xmlns="urn:jboss:domain:jgroups:6.0">
            <channels default="ee">
                <channel name="ee" stack="tcpping"/>
            </channels>
            <stacks>
                <stack name="tcpping">
                    <transport type="TCP" socket-binding="jgroups-tcp">
                        <property name="external_addr">
                            ${jgroups.bind.address:127.0.0.1}
                        </property>
                        <property name="bind_addr">
                            ${jgroups.bind_addr:SITE_LOCAL}
                        </property>
                    </transport>
                    <jdbc-protocol type="JDBC_PING" data-source="KeycloakDS">
                        <property name="initialize_sql">
                            CREATE TABLE IF NOT EXISTS JGROUPSPING (own_addr varchar(200) NOT NULL,bind_addr varchar(200) NOT NULL,created timestamp NOT NULL,cluster_name varchar(200) NOT NULL,ping_data BYTEA,constraint PK_JGROUPSPING PRIMARY KEY (own_addr, cluster_name))
                        </property>
                        <property name="insert_single_sql">
                            INSERT INTO JGROUPSPING (own_addr, bind_addr, created, cluster_name, ping_data) values (?,'${jgroups.bind.address:127.0.0.1}',NOW(), ?, ?)
                        </property>
                        <property name="delete_single_sql">
                            DELETE FROM JGROUPSPING WHERE own_addr=? AND cluster_name=?
                        </property>
                        <property name="select_all_pingdata_sql">
                            SELECT ping_data FROM JGROUPSPING WHERE cluster_name=?;
                        </property>
                    </jdbc-protocol>
                    <protocol type="MERGE3"/>
                    <protocol type="FD_SOCK" socket-binding="jgroups-tcp-fd">
                        <property name="external_addr">
                            ${jgroups.bind.address:127.0.0.1}
                        </property>
                    </protocol>
                    <protocol type="FD"/>
                    <protocol type="VERIFY_SUSPECT"/>
                    <protocol type="pbcast.NAKACK2"/>
                    <protocol type="UNICAST3"/>
                    <protocol type="pbcast.STABLE"/>
                    <protocol type="pbcast.GMS"/>
                    <protocol type="MFC"/>
                    <protocol type="FRAG2"/>
                </stack>
            </stacks>
        </subsystem>
       
       
I do it in my own docker image where I change the configuration with jboss-cli (as in the officilal) with this file :
/subsystem=infinispan/cache-container=keycloak/distributed-cache=sessions:remove
/subsystem=infinispan/cache-container=keycloak/replicated-cache=sessions:add()
/subsystem=infinispan/cache-container=keycloak/replicated-cache=sessions:write-attribute(name="mode",value="SYNC")

/subsystem=infinispan/cache-container=keycloak/distributed-cache=authenticationSessions:remove
/subsystem=infinispan/cache-container=keycloak/distributed-cache=offlineSessions:remove
/subsystem=infinispan/cache-container=keycloak/distributed-cache=clientSessions:remove
/subsystem=infinispan/cache-container=keycloak/distributed-cache=offlineClientSessions:remove
/subsystem=infinispan/cache-container=keycloak/distributed-cache=loginFailures:remove

/subsystem=infinispan/cache-container=keycloak/distributed-cache=authenticationSessions:add(mode="SYNC",owners="2")
/subsystem=infinispan/cache-container=keycloak/distributed-cache=offlineSessions:add(mode="SYNC",owners="2")
/subsystem=infinispan/cache-container=keycloak/distributed-cache=clientSessions:add(mode="SYNC",owners="2")
/subsystem=infinispan/cache-container=keycloak/distributed-cache=offlineClientSessions:add(mode="SYNC",owners="2")
/subsystem=infinispan/cache-container=keycloak/distributed-cache=loginFailures:add(mode="SYNC",owners="2")

/subsystem=jgroups/stack=tcpping:add()
/subsystem=jgroups/stack=tcpping/transport=TCP:add(socket-binding=jgroups-tcp)
/subsystem=jgroups/stack=tcpping/transport=TCP/property=external_addr:add(value=${jgroups.bind.address:127.0.0.1})
/subsystem=jgroups/stack=tcpping/transport=TCP/property=bind_addr:add(value=${jgroups.bind_addr:SITE_LOCAL})


/subsystem=jgroups/stack=tcpping/protocol=JDBC_PING:add(data-source="KeycloakDS", properties=[initialize_sql="CREATE TABLE IF NOT EXISTS JGROUPSPING (own_addr varchar(200) NOT NULL,bind_addr varchar(200) NOT NULL,created timestamp NOT NULL,cluster_name varchar(200) NOT NULL,ping_data BYTEA,constraint PK_JGROUPSPING PRIMARY KEY (own_addr, cluster_name))",insert_single_sql="INSERT INTO JGROUPSPING (own_addr, bind_addr, created, cluster_name, ping_data) values (?,'${jgroups.bind.address:127.0.0.1}',NOW(), ?, ?)",delete_single_sql="DELETE FROM JGROUPSPING WHERE own_addr=? AND cluster_name=?",select_all_pingdata_sql="SELECT ping_data FROM JGROUPSPING WHERE cluster_name=?;"])

/subsystem=jgroups/stack=tcpping/protocol=MERGE3:add()
/subsystem=jgroups/stack=tcpping:add-protocol(type="FD_SOCK",socket-binding="jgroups-tcp-fd")
/subsystem=jgroups/stack=tcpping/protocol=FD_SOCK/property=external_addr:add(value=${jgroups.bind.address:127.0.0.1})
/subsystem=jgroups/stack=tcpping/protocol=FD:add()
/subsystem=jgroups/stack=tcpping/protocol=VERIFY_SUSPECT:add()
/subsystem=jgroups/stack=tcpping/protocol=pbcast.NAKACK2:add()
/subsystem=jgroups/stack=tcpping/protocol=UNICAST3:add()
/subsystem=jgroups/stack=tcpping/protocol=pbcast.STABLE:add()
/subsystem=jgroups/stack=tcpping/protocol=pbcast.GMS:add()
/subsystem=jgroups/stack=tcpping/protocol=MFC:add()
/subsystem=jgroups/stack=tcpping/protocol=FRAG2:add()

/subsystem=jgroups/channel=ee:remove
/subsystem=jgroups/channel=ee:add(stack=tcpping)
/subsystem=jgroups:write-attribute(name=default-channel, value=ee)

/socket-binding-group=standard-sockets/socket-binding=jgroups-tcp:write-attribute(name="interface",value="private")
/socket-binding-group=standard-sockets/socket-binding=jgroups-tcp-fd:add()
/socket-binding-group=standard-sockets/socket-binding=jgroups-tcp-fd:write-attribute(name="interface",value="private")
/socket-binding-group=standard-sockets/socket-binding=jgroups-tcp-fd:write-attribute(name="port",value="57600")


/subsystem=jgroups/stack=tcp:remove
/subsystem=jgroups/stack=udp:remove


I am not sure all is good in this but it works (in my environment :) ).

(the difficulties I had was that if the cli file is like :
...
	/subsystem=jgroups/stack=tcpping/protocol=JDBC_PING:add(data-source="KeycloakDS")
	/subsystem=jgroups/stack=tcpping/protocol=JDBC_PING/property=datasource_jndi_name:add(value=java:jboss/datasources/KeycloakDS)
/subsystem=jgroups/stack=tcpping/protocol=JDBC_PING/property=otherproperty:add(value=other_value)
...

the configuration in xml is :
  <protocol type="org.apache.jgroups.JDBC_PING" >

Which doesn't work (don't know why). There is not a lot of documentation on this, so I'm listening to all suggestions.
 
```
