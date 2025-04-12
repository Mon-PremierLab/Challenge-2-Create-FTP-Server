#!/bin/bash

# TODO: Complétez ce script pour tester les accès FTP.

# Test 1 : Connexion FTP pour un utilisateur du département Développement
echo "Test : Connexion FTP pour ftpuser1 (Développement)"
ftp -inv <IP-FTP-SERVER> <<EOF
user ftpuser1 <password>
ls
bye
EOF

# Test 2 : Connexion FTP pour un utilisateur du département Marketing
echo "Test : Connexion FTP pour ftpuser2 (Marketing)"
# Complétez ici...

# Test 3 : Connexion FTP pour un utilisateur du département RH
echo "Test : Connexion FTP pour ftpuser3 (RH)"
# Complétez ici...

# TODO: Ajoutez des validations pour vérifier que les utilisateurs ne peuvent pas accéder aux répertoires des autres départements.