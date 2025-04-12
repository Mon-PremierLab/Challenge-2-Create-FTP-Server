#!/bin/bash

# TODO: Complétez ce script pour tester les quotas de stockage.

# Vérifiez les quotas pour ftpuser1
echo "Vérification des quotas pour ftpuser1"
repquota /data | grep ftpuser1

# Vérifiez les quotas pour ftpuser2
echo "Vérification des quotas pour ftpuser2"
# Complétez ici...

# Vérifiez les quotas pour ftpuser3
echo "Vérification des quotas pour ftpuser3"
# Complétez ici...

# TODO: Ajoutez des tests pour simuler un dépassement de quota et vérifier le comportement.