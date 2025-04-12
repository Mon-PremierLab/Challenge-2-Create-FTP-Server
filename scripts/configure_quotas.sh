#!/bin/bash

# Script de configuration des quotas disque pour le serveur FTP
# Bonnes pratiques à suivre :
# - Toujours vérifier que le système de fichiers supporte les quotas (ext4, xfs)
# - Tester les commandes avec un utilisateur pilote avant déploiement global
# - Documenter les limites définies pour chaque groupe
# - Mettre en place une surveillance des quotas

# Étape 1 : Activez les quotas sur le système de fichiers
# Points de vérification :
# - Le système de fichiers est-il monté avec les options usrquota,grpquota ?
# - Les fichiers aquota.user et aquota.group existent-ils ?
# Commandes utiles :
# - mount | grep quota : vérifier les options de montage
# - quotacheck -cugm /data : créer les fichiers de quota

# Étape 2 : Configurez les quotas pour chaque utilisateur
# Recommandations :
# - Définir des soft limits (avertissement) et hard limits (bloquant)
# - Adapter les quotas selon les besoins métier de chaque groupe
# - Prévoir une marge de sécurité (80% du hard limit)
# Exemple de limites recommandées :
# - Développement : 10GB soft, 12GB hard
# - Marketing : 5GB soft, 6GB hard
# - RH : 2GB soft, 3GB hard

# Étape 3 : Vérifiez que les quotas sont correctement appliqués
# Points de contrôle :
# - Les quotas sont-ils actifs ? (quotaon -p /data)
# - Les limites sont-elles correctes ? (repquota -a)
# - Les utilisateurs peuvent-ils voir leurs quotas ? (quota -v)
# 
# ATTENTION : N'oubliez pas de tester avec un petit fichier avant
# de déployer en production