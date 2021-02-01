to enable HTTPS for the Keycloak server:

  1) Obtaining or generating a keystore that contains the private key and certificate for SSL/HTTP traffic
  2) Configuring the Keycloak server to use this keypair and certificate.

  1.1) Creating the Certificate and Java Keystore
   to allow HTTPS connections :
       -  you need a self signed or third-party signed certificate 
       - import it into a Java keystore before you can enable HTTPS.

 1.1.1) generate a self-signed one using the keytool
   keytool -genkey -alias localhost -keyalg RSA -keystore keycloak.jks -validity 10950
 1.1.2) import your new CA generated certificate to your keystore:
    $ keytool -import -alias yourdomain -keystore keycloak.jks -file your-certificate.cer
 2) Configure Keycloak to Use the Keystore
     2.2)  move the keystore file to the configuration/ directory (provide an absolute path to it).
      If you are using absolute paths, remove the optional relative-to parameter from your 
      configuration
     2.1) edit standalone-ha.xml file to  use the keystore and enable HTTPS
    
      - Add the new security-realm element using the CLI:
      $ /core-service=management/security-realm=UndertowRealm:add()
      $ /core-service=management/security-realm=UndertowRealm/server-identity=ssl:add(keystore-path=keycloak.jks, keystore-relative-to=jboss.server.config.dir, keystore-password=secret).
      
      in the standalone or host configuration file, the security-realms element should look like this:
      <security-realm name="UndertowRealm">
         <server-identities>
            <ssl>
               <keystore path="keycloak.jks" relative-to="jboss.server.config.dir" keystore-password="secret" />
            </ssl>
         </server-identities>
      </security-realm>
     
     - search for any instances of security-realm. Modify the https-listener to use the created realm:
      $ /subsystem=undertow/server=default-server/https-listener=https:write-attribute(name=security-realm, value=UndertowRealm)
     The resulting element :
     <subsystem xmlns="urn:jboss:domain:undertow:11.0">
       <buffer-cache name="default"/>
       <server name="default-server">
            <https-listener name="https" socket-binding="https" security-realm="UndertowRealm"/>
            ...
       </subsystem>
     
