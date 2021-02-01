#!/usr/bin/env bash

INSTALL_SRC=/vagrant/Install

JGROUPS_DISCOVERY_EXTERNAL_IP=172.21.48.39
JGROUPS_DISCOVERY_PROTOCOL=TCPPING
JGROUPS_DISCOVERY_PROPERTIES=initial_hosts="172.21.48.4[7600],172.21.48.39[7600]"

# If JGROUPS_DISCOVERY_PROPERTIES doit suivre le formatt: PROP1=FOO,PROP2=BAR
# If JGROUPS_DISCOVERY_PROPERTIES_DIRECT doit suivre le formatt: {PROP1=>FOO,PROP2=>BAR
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


    echo " - Ajouter les parametres jgroups ci-dessous a /opt/keycloak/bin/.jbossclirc"
    echo "Setting JGroups discovery to $JGROUPS_DISCOVERY_PROTOCOL with properties $PROPERTIES_VALUE"
    echo "set keycloak_jgroups_discovery_protocol=${JGROUPS_DISCOVERY_PROTOCOL}" >> /opt/keycloak/bin/.jbossclirc
    echo "set keycloak_jgroups_discovery_protocol_properties=${PROPERTIES_VALUE}" >> /opt/keycloak/bin/.jbossclirc
    echo "set keycloak_jgroups_transport_stack=${JGROUPS_TRANSPORT_STACK:-tcp}" >> /opt/keycloak/bin/.jbossclirc
    sudo more /opt/keycloak/bin/.jbossclirc
    
    echo "----------------------------------------------------------------------------------"
    echo " configurer le protocole spécifie si le fichier CLI de configuration de celui-ci  "
    echo " est present sinon on utilise la configuration par defaut                         "
    echo "----------------------------------------------------------------------------------"
    if [ -f "${INSTALL_SRC}/config/jgroups/discovery/${JGROUPS_DISCOVERY_PROTOCOL}.cli" ]; then
       echo " - configuration et utilisation du protocole : ${JGROUPS_DISCOVERY_PROTOCOL}[.cli]"   
       sudo /opt/keycloak/bin/jboss-cli.sh --file="${INSTALL_SRC}/config/jgroups/discovery/$JGROUPS_DISCOVERY_PROTOCOL.cli"  --properties=env.properties >& /dev/null
    else
       echo "utilisation du protocole par defaut : default[.cli]"
       sudo /opt/keycloak/bin/jboss-cli.sh --file="${INSTALL_SRC}/config/jgroups/discovery/default.cli"  --properties=env.properties >& /dev/null
    fi
fi
