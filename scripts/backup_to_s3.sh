#!/bin/bash

# Variables
SOURCE="/data/ftp"
BUCKET_NAME="nabysso-backup-XXX"  # À remplacer par votre nom de bucket
BACKUP_NAME="ftp_backup_$(date +%Y%m%d).tar.gz"

# 1. Compression des données FTP
tar -czf "/tmp/$BACKUP_NAME" "$SOURCE"

# 2. Upload vers S3
aws s3 cp "/tmp/$BACKUP_NAME" "s3://$BUCKET_NAME/backups/"

# 3. Nettoyage local
rm "/tmp/$BACKUP_NAME"

# 4. Rotation sur S3 (suppression des sauvegardes > 7 jours)
aws s3 ls "s3://$BUCKET_NAME/backups/" | while read -r line; do
    createDate=$(echo $line | awk '{print $1}')
    fileName=$(echo $line | awk '{print $4}')
    
    # Convertir la date en timestamp pour comparaison
    fileDate=$(date -d "$createDate" +%s)
    currentDate=$(date +%s)
    daysOld=$(( ($currentDate - $fileDate) / 86400 ))
    
    # Supprimer les fichiers de plus de 7 jours
    if [ $daysOld -gt 7 ]; then
        aws s3 rm "s3://$BUCKET_NAME/backups/$fileName"
        echo "Suppression de la sauvegarde $fileName (âgée de $daysOld jours)"
    fi
done