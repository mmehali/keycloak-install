#!/bin/bash

KEYCLOAK_HOME=/opt/keycloak

if [ -d "${KEYCLOAK_HOME}/secrets" ]; then
    echo "set plaintext_vault_provider_dir=${KEYCLOAK_HOME}/secrets" >> "${KEYCLOAK_HOME}/bin/.jbossclirc"
    echo "set configuration_file=standalone-ha.xml" >> "${KEYCLOAK_HOME}/bin/.jbossclirc"
    /opt/keycloak/bin/jboss-cli.sh --file=config/files-plaintext-vault.cli   
    sed -i '$ d' "/opt/keycloak/bin/.jbossclirc"
fi
