# MonPremierLAB - Configuration d'un Serveur FTP Sécurisé pour NaBysso

## Bienvenue
Bienvenue dans ce challenge d'administration système ! En tant qu'administrateur système chez NaBysso, vous êtes chargé de mettre en place une solution FTP sécurisée sur une instance Amazon Linux préconfiguée.

### Contexte
NaBysso, entreprise de développement logiciel en pleine croissance, est composée de trois départements :
- **Développement** : 10 développeurs travaillant sur du code source sensible
- **Marketing** : 5 personnes gérant les supports de communication
- **RH** : 4 ressources manipulant des données confidentielles

### Problématique
Actuellement :
- Chaque équipe stocke ses fichiers localement sans sauvegarde centralisée
- Aucune gestion des accès ni traçabilité
- Risques élevés de fuites de données sensibles
- Difficultés de collaboration entre les départements
- Pas de politique de quota ou de rétention

## Le challenge
En tant qu'administrateur système, vous devez sécuriser et centraliser le partage de fichiers :

1. **Configuration du serveur VSFTPD**
   - Installation et configuration sécurisée
   - Gestion des connexions FTP
   - Mise en place de la journalisation

2. **Gestion des accès**
   - Structure de répertoires par département
   - Permissions et droits d'accès spécifiques
   - Isolation des données sensibles

3. **Optimisation des ressources**
   - Quotas de stockage par département
   - Surveillance de l'utilisation
   - Gestion des sauvegardes

4. **Challenge Supplémentaire : Intégration Cloud**
   - Sauvegarde automatique sur un Bucket Amazon S3

> **⚠️ Note importante sur la sécurité en production**
>
> Ce lab utilise une configuration FTP simplifiée à des fins pédagogiques. En production, il n'est pas recommandé d'exposer directement un serveur FTP sur Internet pour des raisons de sécurité.
>
> **Approches recommandées en production :**
> - Utiliser SFTP (SSH File Transfer Protocol) au lieu de FTP
> - Mettre en place un VPN pour accéder au serveur de fichiers
> - Utiliser AWS Transfer Family pour un service de transfert de fichiers géré et sécurisé
> - Implémenter une solution de stockage objet comme AWS S3 avec des accès pré-signés
>
> Ces solutions offrent un niveau de sécurité plus élevé et sont mieux adaptées à un environnement de production.

### Environnement de travail
Pour réaliser ce challenge, vous avez plusieurs options :

1. **Environnement Local**
   - Utilisez une machine virtuelle locale (VirtualBox, VMware)
   - Installez Amazon Linux 2023 ou une distribution Linux de votre choix
   - Configurez les ports nécessaires (20, 21 et ports passifs FTP 30000-30100)

2. **Cloud AWS**
   - Utilisez le template CloudFormation fourni (`infrastructure/ftp-server-infra.yml`)
   - **Important** : Ce template doit être déployé dans la région **us-west-2**
   - Il déploiera automatiquement dans votre compte AWS :
     - Un VPC avec un sous-réseau public
     - Une instance Amazon Linux 2023
     - Un volume EBS de 50 Go
     - Les Security Groups pour FTP
     - Les ressources IAM nécessaires

3. **Sandbox MonPremierLab**
   - Contactez notre support via monpremierlab@gmail.com 
   - Nous vous fournirons un accès à un environnement préconfiguré
   - Durée d'accès : 2 heures
   - **Architecture de votre infrastructure**
  ![Architecture de votre Stack sur AWS](ftp-server-stack.png)

> **Note** : Les instructions de ce lab sont basées sur Amazon Linux 2023, mais peuvent être adaptées à d'autres distributions Linux.

## Résultat attendu
Votre serveur FTP doit répondre aux exigences suivantes :

- Structure de répertoires :
  ```
  /data/ftp/
  ├── development/
  ├── marketing/
  └── hr/
  ```
- Permissions spécifiques par département
- Quotas de stockage (5GB/département)
- Logs de connexion et d'activité
- Documentation de configuration

## Où tout trouver
### Documentations officielles

- **VSFTPD** :
  - [Manuel officiel](https://security.appspot.com/vsftpd.html)
  - [Page man](https://man.cx/vsftpd.conf(5))
  - [Wiki Archlinux VSFTPD](https://wiki.archlinux.org/title/Very_Secure_FTP_Daemon)

- **Commandes Linux utiles** :
  - `useradd` : [Documentation](https://man7.org/linux/man-pages/man8/useradd.8.html)
  - `chmod` : [Guide des permissions](https://man7.org/linux/man-pages/man1/chmod.1.html)
  - `chown` : [Documentation](https://man7.org/linux/man-pages/man1/chown.1.html)
  - `quota` : [Guide quotas](https://man7.org/linux/man-pages/man1/quota.1.html)
  
- `infrastructure/` : Ressources pour le déploiement
  - `nabysso-ftp-infra.yml` : Template CloudFormation AWS
  - `README.md` : Guide de déploiement

- `scripts/` : Scripts d'automatisation
  - `create_users.sh` : Création des utilisateurs et groupes
  - `setup_vsftpd.sh` : Configuration initiale du serveur
  - `configure_quotas.sh` : Mise en place des quotas
  - `setup_backup.sh` : Configuration des sauvegardes

- `config/` : Fichiers de configuration
  - `vsftpd.conf` : Template de configuration VSFTPD
  - `groups.conf` : Configuration des groupes utilisateurs
  - `quotas.conf` : Configuration des quotas

- `tests/` : Scripts de validation
  - `test_ftp_access.sh` : Test des accès FTP
  - `test_permissions.sh` : Vérification des permissions
  - `test_quotas.sh` : Validation des quotas


## Construire votre projet

### Étape 1 : Connexion à l'instance
Si vous utilisez l'environnement AWS ou la Sandbox MonPremierLab, connectez-vous à l'instance via SSH :
```bash
ssh -i ./credentials/nabysso-key.pem ec2-user@<IP-FOURNIE>
```

### Étape 2 : Préparation des scripts
Avant d'exécuter les scripts fournis, vous devez les rendre exécutables :
```bash
# Rendez tous les fichiers .sh du dossier scripts exécutables
chmod +x ./scripts/*.sh
```

### Étape 3 : Installation des packages nécessaires
Assurez-vous que tous les outils requis sont installés :
```bash
# Mettre à jour les packages
sudo dnf update -y

# Installer VSFTPD et les outils de gestion des quotas
sudo dnf install -y vsftpd quota
```

### Étape 4 : Configuration initiale de VSFTPD
1. Démarrez et activez le service VSFTPD :
```bash
# Assurez-vous que le service VSFTPD est démarré et configuré pour démarrer automatiquement au démarrage du système.
```

2. Sauvegardez la configuration par défaut :
```bash
# Sauvegardez la configuration par défaut de VSFTPD pour pouvoir y revenir si nécessaire.
sudo cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig
```

3. Remplacez la configuration par le fichier fourni :
```bash
sudo cp ./config/vsftpd.conf /etc/vsftpd/vsftpd.conf
```

4. Redémarrez le service pour appliquer les modifications :
```bash
# Appliquez les modifications en redémarrant le service VSFTPD.
sudo systemctl restart vsftpd
```

### Étape 5 : Création de la structure des répertoires
1. Créez les répertoires pour chaque département :
```bash
# Utiliser la command mkdir pour créer les repertoires
```

2. Attribuez les permissions et le propriétaire appropriés :
```bash
# Change le propriétaire et le groupe des répertoires en 'ftp'

sudo chown -R ftp:ftp /data/ftp/

# Définit les permissions pour que seul le propriétaire ait un accès complet, 
# le groupe ait un accès en lecture/exécution, et aucun accès pour les autres
sudo chmod -R 750 /data/ftp/
```

### Étape 6 : Gestion des utilisateurs
1. Créez des utilisateurs pour chaque département :
```bash
# Exécute le script pour créer les utilisateurs et les associer à leurs départements respectifs

sudo ./scripts/create_users.sh
```

2. Vérifiez que les utilisateurs ont été créés correctement :
```bash
cat /etc/passwd | grep ftpuser
```

### Étape 7 : Mise en place des quotas
1. Configurez les quotas pour le volume `/data` :
```bash
sudo ./scripts/configure_quotas.sh
```

2. Vérifiez les quotas appliqués :
```bash
sudo repquota /data
```

### Étape 8 : Tests et validation
1. Testez les accès FTP avec les scripts fournis :
```bash
./tests/test_ftp_access.sh
./tests/test_permissions.sh
./tests/test_quotas.sh
```

2. Vérifiez les logs pour vous assurer que tout fonctionne correctement :
```bash
sudo tail -f /var/log/vsftpd.log
```

### Étape 9 : Challenge Supplémentaire: Sauvegarde des données sur Amazon S3

**Qu'est-ce qu'Amazon S3 ?**
Amazon Simple Storage Service (S3) est un service de stockage d'objets qui offre une scalabilité, une disponibilité des données, une sécurité et des performances de pointe. Il permet de stocker et de protéger n'importe quelle quantité de données pour différents cas d'utilisation comme :
- Les sauvegardes et restaurations
- L'archivage des données
- Les sites web statiques
- Les applications natives cloud

**Objectif :** Configurez une sauvegarde automatique des fichiers FTP vers Amazon S3.

#### Prérequis
- Un compte AWS avec accès à S3
- Les informations d'identification IAM appropriées
- AWS CLI installé sur l'instance

#### Instructions de configuration

1. **Créer un bucket S3**
   - Nom suggéré : `nabysso-backup-<votre-identifiant>`
   - Région : celle la plus proche de votre instance
   - Configuration recommandée : 
     - Versioning activé
     - Chiffrement côté serveur
     - Politique de cycle de vie pour les anciennes sauvegardes

2. **Configuration de l'AWS CLI**
   ```bash
   # Installation de l'AWS CLI
   sudo dnf install -y aws-cli

   # Configuration des credentials
   aws configure
   ```

3. **Script de sauvegarde**
   Créez un script nommé `backup_to_s3.sh` :
   ```bash
   #!/bin/bash
   
   # Variables à configurer
   BACKUP_DIR="/data/ftp"
   S3_BUCKET="votre-bucket-s3"
   BACKUP_NAME="ftp_backup_$(date +%Y%m%d_%H%M%S).tar.gz"

   # Création de la sauvegarde
   echo "Création de la sauvegarde..."
   tar -czf "/tmp/$BACKUP_NAME" "$BACKUP_DIR"

   # Envoi vers S3
   echo "Envoi vers S3..."
   aws s3 cp "/tmp/$BACKUP_NAME" "s3://$S3_BUCKET/backups/"

   # Nettoyage
   rm "/tmp/$BACKUP_NAME"
   ```

4. **Automatisation avec Cron**
   ```bash
   # Éditer le crontab
   crontab -e

   # Ajouter la ligne suivante pour une sauvegarde quotidienne à 2h du matin
   0 2 * * * /scripts/backup_to_s3.sh
   ```

#### Validation
- Vérifiez que le script fonctionne manuellement
- Confirmez que les sauvegardes apparaissent dans le bucket S3
- Testez la restauration d'une sauvegarde

#### Points bonus
- Mettre en place une rotation des sauvegardes
- Ajouter une notification en cas d'échec
- Implémenter un système de surveillance des tailles de sauvegarde

## Des feedback pour nous?
Vos retours sont précieux ! Partagez votre expérience sur :
- La clarté des instructions
- Les difficultés avec Amazon Linux
- Les suggestions d'amélioration

Ce lab fait partie de la série MonPremierLab - Formation pratique en administration système.

Cet atelier est entièrement gratuit. N'hésitez pas à le partager avec toute personne susceptible d'en bénéficier.