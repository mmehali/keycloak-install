#!/usr/bin/env bash

source ./realms/intranet/config.sh

# configuration des providers saml
source ./realms/intranet//identity-providers/saml/configure_saml.sh

# configuration des providers oidc
source ./realms/intranet/identity-providers/oidc/configure_oidc.sh


