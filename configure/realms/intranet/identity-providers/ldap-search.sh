ldapsearch --hostname localhost --port 1389 --bindDN "cn=Directory Manager" \
--bindPassword password --baseDN dc=example,dc=com "(&(sn=jensen)(l=Cupertino))"
