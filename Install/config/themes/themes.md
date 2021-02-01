### Ajouter un thème personnalisé
Pour ajouter un thème personnalisé, ajoutez le thème au répertoire /opt/keycloak/themes.

Pour définir le thème de bienvenue, utilisez la valeur d'environnement suivante:

- KEYCLOAK_WELCOME_THEME: Spécifiez le thème à utiliser pour la page d'accueil (doit être non vide et doit correspondre à un nom de thème existant)

Pour définir votre thème personnalisé comme thème global par défaut, utilisez la valeur d'environnement suivante:

KEYCLOAK_DEFAULT_THEME: Spécifiez le thème à utiliser comme thème global par défaut (doit correspondre à un nom de thème existant, s'il est vide, il utilisera keycloak)