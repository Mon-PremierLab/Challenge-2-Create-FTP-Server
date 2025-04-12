#!/bin/bash

# TODO: Complétez ce script pour créer les utilisateurs FTP pour chaque département.

# Exemple : Créez un utilisateur pour le département Développement
# Utilisez la commande `useradd` pour créer un utilisateur
# Assurez-vous que chaque utilisateur a un répertoire personnel dans /data/ftp/<department>

# Créez les utilisateurs pour le département Développement
# useradd -d /data/ftp/development/<username> -s /sbin/nologin <username>

# Créez les utilisateurs pour le département Marketing
# ...

# Créez les utilisateurs pour le département RH
# ...

# Assurez-vous que les permissions des répertoires sont correctement configurées
# Utilisez `chown` et `chmod` pour attribuer les bons droits