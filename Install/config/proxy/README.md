

### Activation du transfert d'adresse proxy (proxy address forwarding)

Lorsque keycloak s'execute derrière un proxy, vous devrez activer le transfert d'adresse proxy.

PROXY_ADDRESS_FORWARDING = true

- pour le http :
```
/subsystem=undertow/server=default-server/http-listener=default: write-attribute(  \
   name=proxy-address-forwarding,                                                  \
   value=${env.PROXY_ADDRESS_FORWARDING:false}                                     \
   )
```
- pour le https :
```
/subsystem=undertow/server=default-server/https-listener=https: write-attribute(  \
   name=proxy-address-forwarding,                                                 \
   value=${env.PROXY_ADDRESS_FORWARDING:false}                                    \
   )
```

Keycloak pourra donc extraire l’adresse IP du client de l’en-tête **X-Forwarded-For** du proxy plutôt 
que du paquet réseau. 
