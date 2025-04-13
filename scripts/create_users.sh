# Guide de création d'un utilisateur FTP sécurisé avec chroot
# Remplacez <BASE_PATH> par votre chemin de base (exemple: /home/ec2-user)
# Remplacez <USERNAME> par le nom d'utilisateur souhaité

# 1. Création de la structure des dossiers
# Important : Pour que le chroot fonctionne, la structure doit être :
# - Dossier racine : appartient à root, droits 755
# - Dossier upload : appartient à l'utilisateur, droits 755 ou plus restrictifs

# Création des dossiers
sudo mkdir -p <BASE_PATH>/data/ftp/development/<USERNAME>/upload

# 2. Création de l'utilisateur FTP
# Le répertoire home doit pointer vers le dossier upload
sudo useradd -d <BASE_PATH>/data/ftp/development/<USERNAME>/upload -s /sbin/nologin <USERNAME>

# 3. Vérification
cat /etc/passwd | grep <USERNAME>

# 4. Configuration vsftpd
sudo echo "<USERNAME>" | sudo tee -a /etc/vsftpd/user_list

# 5. Shell Configuration
sudo echo "/sbin/nologin" | sudo tee -a /etc/shells

# 6. Configuration des permissions pour le chroot
# IMPORTANT: Ces permissions sont obligatoires pour que le chroot fonctionne
# Le dossier parent DOIT appartenir à root et avoir les droits 755
sudo chown root:root <BASE_PATH>/data/ftp/development/<USERNAME>
sudo chmod 755 <BASE_PATH>/data/ftp/development/<USERNAME>

# 7. Configuration du dossier upload
# L'utilisateur aura accès uniquement à ce dossier
sudo chown <USERNAME>:<USERNAME> <BASE_PATH>/data/ftp/development/<USERNAME>/upload
sudo chmod 755 <BASE_PATH>/data/ftp/development/<USERNAME>/upload

# 8. Vérification des permissions (Important)
echo "Vérification de la structure et des permissions :"
echo "1. Le dossier parent doit appartenir à root:root avec les droits 755 :"
ls -ld <BASE_PATH>/data/ftp/development/<USERNAME>
echo "2. Le dossier upload doit appartenir à <USERNAME>:<USERNAME> :"
ls -ld <BASE_PATH>/data/ftp/development/<USERNAME>/upload

# 9. Test de la configuration
echo "2. Vérifiez les logs : sudo tail -f /var/log/vsftpd.log"
echo "3. En cas d'erreur 500, vérifiez que le dossier parent appartient bien à root"

# Note: Pour que le chroot fonctionne, assurez-vous que ces paramètres sont présents dans vsftpd.conf:
# chroot_local_user=YES
# allow_writeable_chroot=YES

# Pour créer d'autres utilisateurs, répétez ces étapes en changeant <USERNAME>