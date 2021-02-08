#!/usr/bin/env bash

INSTALL_SRC=/opt/keycloak-install
KEYCLOAK_HOME=/opt/keycloak

JGROUPS_DISCOVERY_EXTERNAL_IP=$(hostname -I | awk '{print $1}')
# TCP 
#JGROUPS_DISCOVERY_PROTOCOL=TCPPING
#JGROUPS_DISCOVERY_PROPERTIES=initial_hosts="172.21.48.4[7600],172.21.48.39[7600]"

#JDBC_PING
JGROUPS_DISCOVERY_PROTOCOL=JDBC_PING
JGROUPS_DISCOVERY_PROPERTIES=datasource_jndi_name=java:jboss/datasources/KeycloakDS,info_writer_sleep_time=500,initialize_sql="CREATE TABLE IF NOT EXISTS JGROUPSPING ( own_addr varchar(200) NOT NULL, cluster_name varchar(200) NOT NULL, created timestamp default current_timestamp, ping_data BYTEA, constraint PK_JGROUPSPING PRIMARY KEY (own_addr, cluster_name))"



# JGROUPS_DISCOVERY_PROPERTIES doit suivre le format: PROP1=FOO,PROP2=BAR
# JGROUPS_DISCOVERY_PROPERTIES_DIRECT doit suivre le formatt: {PROP1=>FOO,PROP2=>BAR
if [ -n "$JGROUPS_DISCOVERY_PROTOCOL" ]; then
    if [ -n "$JGROUPS_DISCOVERY_PROPERTIES" ] && [ -n "$JGROUPS_DISCOVERY_PROPERTIES_DIRECT" ]; then
       echo >&2 "error: une seule propriété doit être initilisé : pas les deux en même temps"
       exit 1
    fi

    if [ -n "$JGROUPS_DISCOVERY_PROPERTIES_DIRECT" ]; then
       PROPERTIES_VALUE="$JGROUPS_DISCOVERY_PROPERTIES_DIRECT"
    else
       PROPERTIES_VALUE=`echo $JGROUPS_DISCOVERY_PROPERTIES | sed "s/=/=>/g"`
       PROPERTIES_VALUE="{$PROPERTIES_VALUE}"
    fi


    echo " - Ajouter les parametres jgroups ci-dessous a ${KEYCLOAK_HOME}/bin/.jbossclirc"
    echo "Setting JGroups discovery to $JGROUPS_DISCOVERY_PROTOCOL with properties $PROPERTIES_VALUE"
    echo "set keycloak_jgroups_discovery_protocol=${JGROUPS_DISCOVERY_PROTOCOL}" >> ${KEYCLOAK_HOME}/bin/.jbossclirc
    echo "set keycloak_jgroups_discovery_protocol_properties=${PROPERTIES_VALUE}" >> ${KEYCLOAK_HOME}/bin/.jbossclirc
    echo "set keycloak_jgroups_transport_stack=${JGROUPS_TRANSPORT_STACK:-tcp}" >> ${KEYCLOAK_HOME}/bin/.jbossclirc
    sudo more ${KEYCLOAK_HOME}/bin/.jbossclirc
    
    echo "----------------------------------------------------------------------------------"
    echo " configurer le protocole spécifie si le fichier CLI de configuration de celui-ci  "
    echo " est present sinon on utilise la configuration par defaut                         "
    echo "----------------------------------------------------------------------------------"
    if [ -f "${INSTALL_SRC}/config/jgroups/discovery/${JGROUPS_DISCOVERY_PROTOCOL}.cli" ]; then
       echo " - configuration et utilisation du protocole : ${JGROUPS_DISCOVERY_PROTOCOL}[.cli]"   
       sudo ${KEYCLOAK_HOME}/bin/jboss-cli.sh --file="${INSTALL_SRC}/config/jgroups/discovery/$JGROUPS_DISCOVERY_PROTOCOL.cli"  
       #>& /dev/null
    else
       echo "utilisation du protocole par defaut : default[.cli]"
       sudo ${KEYCLOAK_HOME}/bin/jboss-cli.sh --file="${INSTALL_SRC}/config/jgroups/discovery/default.cli"  
       #>& /dev/null
    fi
fi
