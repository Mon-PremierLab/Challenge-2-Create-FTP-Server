![alt text](MonPremierLab-Logo.jpg){ width=100px }
# MonPremierLAB - Configuration d'un Serveur FTP Sécurisé pour NaBysso

## Bienvenue
Bienvenue dans ce challenge d'administration système ! En tant qu'administrateur système chez NaBysso, vous êtes chargé de mettre en place une solution FTP sécurisée sur une instance Amazon Linux préconfiguée.

## Prérequis
- Connaissance de base des commandes Linux
- Un client FTP (FileZilla, WinSCP, ou autre)
- Un éditeur de texte (vim, nano)
- Un terminal SSH
- Accès à AWS (optionnel)

## Qu'est-ce qu'un serveur FTP ?
Le FTP (File Transfer Protocol) est un protocole standard d'Internet permettant le transfert de fichiers entre un client et un serveur sur un réseau informatique.

### Caractéristiques principales
- **Transfert de fichiers** : Permet l'upload et le download de fichiers
- **Architecture client-serveur** : Fonctionne avec un serveur central et des clients FTP
- **Authentification** : Gère les accès via un système d'utilisateurs/mots de passe
- **Gestion des droits** : Contrôle les permissions d'accès aux fichiers et répertoires

### Fonctionnement
1. **Connexion** : Le client se connecte au serveur (port 21 par défaut)
2. **Authentification** : L'utilisateur fournit ses identifiants
3. **Navigation** : Parcours des répertoires autorisés
4. **Transfert** : Échange de fichiers via un canal de données (port 20 ou ports passifs)

### Types de connexions
- **FTP actif** : Le serveur initie la connexion de données
- **FTP passif** : Le client initie la connexion de données (plus sécurisé)

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

1. **Configuration du serveur VSFTPD (Very Secure FTP Daemon)**
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
     - Les Security Groups pour une instance de machine virtuelle sur laquelle tournera votre serveur FTP
     - Les ressources IAM nécessaires

3. **Sandbox MonPremierLab**
   - Si vous n'avez pas de compte AWS, vous pouvez contacter notre support via monpremierlab@gmail.com 
   - Nous vous fournirons un accès à un environnement préconfiguré pour ce lab
   - Durée d'accès : 2 heures
  
#### Architecture de votre infrastructure sur AWS
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
- Documentation de votre configuration

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
  - `README.md` : Guide de déploiement d'un template CloudFormation

- `scripts/` : Scripts d'automatisation
  - `create_users.sh` : Création des utilisateurs et groupes
  - `backup_to_s3.sh` : Configuration des sauvegardes

- `config/` : Fichiers de configuration
  - `vsftpd.conf` : Template de configuration VSFTPD
  - `groups.conf` : Configuration des groupes utilisateurs
  - `quotas.conf` : Configuration des quotas

- `tests/` : Scripts de validation
  - `test_permissions.sh` : Vérification des permissions
  - `test_quotas.sh` : Validation des quotas


## Construire votre projet

### Étape 1 : Connexion à l'instance (⏱️ ~5 minutes)
Si vous utilisez l'environnement AWS ou la Sandbox MonPremierLab, connectez-vous à l'instance via SSH :
```bash
ssh -i ./credentials/MPL-KeyPairLab.pem ec2-user@<IP-FOURNIE>
```

### Points de contrôle - Étape 1
✓ La connexion SSH est établie
✓ Vous avez accès à la ligne de commande
✓ La clé SSH est correctement utilisée

### Étape 2 : Vérification de l'environnement distant (⏱️ ~5 minutes)
```bash
# Vérifiez l'environnement de travail
pwd
ls -la
```

### Étape 3 : Transfert des fichiers (⏱️ ~10 minutes)
Une fois connecté, transférez les fichiers nécessaires sur votre instance :

```bash
# Depuis un nouveau terminal sur votre machine locale
scp -i ./credentials/MPL-KeyPairLab.pem -r ./scripts ./config ./tests ec2-user@<IP-FOURNIE>:~
```

Dans le terminal SSH connecté au serveur, vérifiez que les fichiers ont été correctement transférés :
```bash
ls -la ~/scripts ~/config ~/tests
```

### Points de contrôle - Étape 3
✓ Les fichiers sont correctement transférés
✓ La structure des répertoires est conforme
✓ Les permissions des fichiers sont correctes

### Étape 4 : Préparation des scripts
Avant d'exécuter les scripts fournis, vous devez les rendre exécutables :
```bash
# Rendez tous les fichiers .sh du dossier scripts exécutables
chmod +x ./scripts/*.sh
```

### Étape 5 : Installation des packages nécessaires
Assurez-vous que tous les outils requis sont installés :
```bash
# Mettre à jour les packages
sudo dnf update -y

# Installer VSFTPD et les outils de gestion des quotas
sudo dnf install -y vsftpd quota
```

### Étape 6 : Configuration initiale de VSFTPD (⏱️ ~20 minutes)

1. Sauvegardez d'abord la configuration par défaut :
```bash
# Créer une sauvegarde du fichier de configuration original
sudo cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
```

2. Examinez le fichier de configuration fourni :
```bash
# Prenez le temps d'analyser le fichier de configuration
cat ./config/vsftpd.conf
```

Le fichier de configuration est structuré en plusieurs sections :
- Sécurité niveau 1 : Configuration de base (accès anonyme, chroot)
- Sécurité niveau 2 : Isolation des utilisateurs
- Sécurité niveau 4 : Configuration des logs
- Configuration du mode passif

3. Remplacez l'IP publique dans le fichier de configuration :
```bash
# Récupérez l'IP publique de votre instance
PUBLIC_IP=$(curl http://checkip.amazonaws.com)

# Remplacez la variable ${PUBLIC_IP} dans le fichier de configuration
sed "s/\${PUBLIC_IP}/$PUBLIC_IP/" ./config/vsftpd.conf > vsftpd.conf.tmp
sudo mv vsftpd.conf.tmp /etc/vsftpd/vsftpd.conf
```

4. Sauvegardez la configuration par défaut de VSFTPD:
```bash
sudo cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig
```

5. Mettez à jour le propriétaire du fichier `/etc/vsftpd/vsftpd.conf`
```bash
sudo chown root:root /etc/vsftpd/vsftpd.conf
```
6. Attribuez les bons droits au fichier `/etc/vsftpd/vsftpd.conf`
```bash
sudo chmod 600 /etc/vsftpd/vsftpd.conf
```

7. Redémarrez le service pour appliquer les modifications :
```bash
sudo systemctl restart vsftpd
```

1. Vérifiez que le service est bien démarré :
```bash
sudo systemctl status vsftpd
```

### Points de contrôle - Étape 6
✓ Le fichier vsftpd.conf a été analysé et compris
✓ L'IP publique a été correctement remplacée
✓ Le service VSFTPD est en cours d'exécution
✓ Les tests de connexion sont positifs

### Étape 7 : Structure et Permissions

1. **Vue d'ensemble de l'arborescence**
```ascii
/data/ftp/
├── development/
│   └── justin/
│       └── upload/
├── marketing/
│   └── user1/
│       └── upload/
└── hr/
    └── user1/
        └── upload/
```

2. **Configuration cible par niveau**
```ascii
Niveau    Propriétaire    Droits    Exemple
-----------------------------------------------
Racine    root:root      755       /data/ftp
Dépt      root:root      755       development/
User      root:root      755       justin/
Upload    justin:justin   700       upload/
```

3. **Création d'un utilisateur FTP**

   a. Préparation
   ```bash
   # Définir les variables
   USERNAME="justin"
   DEPT="development"
   ```

   b. Création d'un utilisateur pour accéder au service FTP
   ```bash
   # Création de l'utilisateur
   sudo useradd -d /data/ftp/$DEPT/$USERNAME/upload -s /sbin/nologin $USERNAME
   sudo echo "$USERNAME" | sudo tee -a /etc/vsftpd/user_list
   ```

   c. Définition d'un mot de passe pour l'utilisateur nouvellement créé
   ```bash
   sudo passwd $USERNAME
   ```
   d. Structure et permissions de l'arborescence
   ```bash
   # Création de l'arborescence complète
   sudo mkdir -p /data/ftp/$DEPT/$USERNAME/upload

   # Configuration des permissions
   sudo chown root:root /data/ftp/$DEPT/$USERNAME
   sudo chmod 755 /data/ftp/$DEPT/$USERNAME
   sudo chown $USERNAME:$USERNAME /data/ftp/$DEPT/$USERNAME/upload
   sudo chmod 700 /data/ftp/$DEPT/$USERNAME/upload
   ```

   e. Ajouter /sbin/nologin à la liste des shells autorisés (important)
   ```bash
   # Pour permettre à VSFTPD d'accepter les utilisateurs avec ce shell
   # ajoute-le à la liste des shells valides :
   echo "/sbin/nologin" | sudo tee -a /etc/shells
   ```


4. **Liste de contrôle**
✓ Arborescence créée
✓ Permissions correctes à chaque niveau
✓ Utilisateur créé avec shell nologin
✓ Utilisateur ajouté à vsftpd.user_list

### Points importants à retenir
- Le dossier parent doit TOUJOURS appartenir à root (exigence chroot)
- Seul le dossier 'upload' appartient à l'utilisateur
- Les permissions 755 sont nécessaires pour la navigation
- Les permissions 700 sur upload assurent la sécurité

1. **Vérification des permissions**
```bash
# Vérifier la structure du dossier utilisateur
ls -la /data/ftp/development/justin
# Doit montrer : propriétaire root:root avec droits 755

ls -la /data/ftp/development/justin/upload
# Doit montrer : propriétaire justin:justin avec droits 700
```

2. **Mise à jour des configurations du service VSFTPD**
```bash
# Redémarrer le service
sudo systemctl restart vsftpd

# Vérifiez que le service est bien démarré
sudo systemctl status vsftpd
```

### Étape 8 : Test et Validation

1. **Test avec FileZilla**
   FileZilla est un client FTP gratuit et open-source qui offre une interface graphique intuitive pour les transferts de fichiers.

   Configuration de la connexion :
   - Hôte : `sftp://<votre-ip>`
   - Port : 21
   - Type d'authentification : Normale
   - Identifiant : votre_utilisateur
   - Mot de passe : votre_mot_de_passe

   Étapes de test :
   1. Ouvrez FileZilla
   2. Entrez les informations de connexion dans la barre rapide en haut
   3. Cliquez sur "Connexion rapide"
   4. Vérifiez que vous pouvez voir le dossier 'upload'
   5. Essayez de téléverser un fichier test
   6. Assurez-vous que l'utilisateur ne peut pas naviguer en dehors du répertoire assigné grâce à l'isolation chroot.

2. **Vérification des logs**
```bash
# Surveillance des connexions en temps réel
sudo tail -f /var/log/vsftpd.log
```

3. **Résolution des problèmes courants**
- Si vous rencontrez des problèmes de connexion, essayez de passer en mode passif dans les paramètres de FileZilla
- Si erreur 500 : Vérifier que le dossier parent appartient à root
- En cas d'erreur 550, vérifiez les permissions du dossier 'upload'.
- En cas d'erreur de connexion, vérifiez la configuration du pare-feu et l'ouverture des ports (20, 21)

### Étape 9 : Configuration des quotas (Optionnel)

Les quotas disque permettent de contrôler l'espace de stockage utilisable par utilisateur ou groupe sur un système Linux. Cette fonctionnalité est essentielle pour :

- **Types de quotas** :
  - `usrquota` : Limite par utilisateur
  - `grpquota` : Limite par groupe

- **Avantages** :
  - Prévention de la saturation du disque
  - Répartition équitable des ressources entre départements
  - Protection contre les attaques par déni de service (DoS)
  - Meilleure gestion des ressources système

1. **Installation des outils de quota**
```bash
sudo dnf install -y quota
```
### Configuration du stockage pour les quotas

La mise en place des quotas nécessite une configuration spéciale du système de fichiers. Cette étape est cruciale si vous :
- Utilisez un volume EBS séparé pour les données FTP
- Souhaitez implémenter des limites de stockage par utilisateur
- Avez besoin de gérer l'espace disque de manière stricte

Suivez ces étapes dans l'ordre :

#### 🧱 1. Identification du volume
```bash
# Lister tous les volumes disponibles
lsblk

# Exemple de sortie :
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  8G  0 disk
└─xvda1 202:1    0  8G  0 part /
xvdf    202:80   0 20G  0 disk   # ← votre disque secondaire
```

> ⚠️ **Important** : Notez le nom de votre volume (ex: xvdf) pour les commandes suivantes

#### 2. Formatage du volume
```bash
# Uniquement pour un nouveau volume
sudo mkfs.ext4 /dev/xvdf
```

#### 3. Création du point de montage
```bash
# Créer le répertoire qui servira de point de montage
sudo mkdir -p /data
```

#### 4. Montage initial
```bash
# Monter le volume
sudo mount /dev/xvdf /data
```

#### 5. Configuration permanente avec quotas
```bash
# Ajouter le montage avec support des quotas dans fstab
echo "/dev/xvdf /data ext4 defaults,usrquota,grpquota 0 2" | sudo tee -a /etc/fstab
```

#### 6. Application des modifications
```bash
# Remonter le volume avec les nouvelles options
sudo mount -o remount /data
```

> **Pourquoi ces étapes ?**
> - Le formatage prépare le volume pour le système de fichiers Linux
> - Les options usrquota et grpquota activent le support des quotas
> - La modification de fstab rend les changements permanents après redémarrage
> - Le remontage active immédiatement les nouvelles options

#### 7. **Activation des quotas**
```bash
# Initialisation des quotas
sudo quotacheck -cugm /data
sudo quotaon -v /data

# La commande setquota permet de définir les limites de stockage en blocs (1 bloc = 1 Ko). Par exemple, 5242880 blocs correspondent à 5 Go.

# Configuration des limites (exemple : 5GB)

sudo setquota -u justin 5242880 5242880 0 0 /data
```

### Étape 10 : Configuration des Sauvegardes S3

Le script `backup_to_s3.sh` gère la sauvegarde automatique de vos données FTP vers Amazon S3.

1. **Configuration du script**
```bash
chmod +x scripts/backup_to_s3.sh
# Modifiez BUCKET_NAME dans le script avec votre nom de bucket
```

2. **Fonctionnalités principales**
- Compression des données FTP
- Upload automatique vers S3
- Rotation automatique (suppression après 7 jours)
- Nettoyage local post-upload

3. **Vérification**
```bash
# Test manuel du script
./scripts/backup_to_s3.sh

# Vérification des sauvegardes sur S3
aws s3 ls s3://votre-bucket/backups/
```

### Points importants
- L'instance profile doit avoir les permissions S3 nécessaires
- Vérifiez que le bucket S3 existe avant l'exécution
- Configurez une tâche cron pour l'exécution automatique

## Des feedback pour nous?
Vos retours sont précieux ! Partagez votre expérience sur :
- La clarté des instructions
- Les difficultés avec Amazon Linux
- Les suggestions d'amélioration

Ce lab fait partie de la série MonPremierLab - Formation pratique en administration système.

Cet atelier est entièrement gratuit. N'hésitez pas à le partager avec toute personne susceptible d'en bénéficier.