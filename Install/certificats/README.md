## Étapes pour créer un certificat auto-signé à l'aide d'OpenSSL
Vous trouverez ci-dessous les étapes pour créer un certificat auto-signé à l'aide d'OpenSSL:

### STEP 1 : créez une clé privée et un certificat public
Créez une clé privée et un certificat public à l'aide de la commande suivante:
```
openssl req -newkey rsa:2048 -x509 -keyout cakey.pem -out cacert.pem -days 3650 
```

- **cakey.pem** est la clé privée
- **cacert.pem** est le certificat publique

ou 
```
openssl genrsa 2048 > host.key
chmod 400 host.key
openssl req -new -x509 -nodes -sha256 -days 365 -key host.key -out host.cert
```
- pour afficher le certificat public 
```
  openssl x509 -in cacert.pem -noout -text
```
- Pour concaténer la clé privée et le certificat public dans un fichier pem (requis pour de nombreux serveurs Web)::
```
cat cakey.pem cacert.pem > server.pem  
```
