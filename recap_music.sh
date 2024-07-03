#!/bin/bash
######CONFIGURATION###########################################################
COLLECTION="/music/path/"
DOSSIER=/path/to/liste1/file/ #this file is a base for check differences with music folder
DATE=$(date "+%y%m%d_%H%M")
LOG=recap_music.txt
DOSSIERLOGS=/path/for/logs/
######CONFIGURATION###########################################################

if [ ! -d $DOSSIER ];then
echo "Création du dossier1 !";
mkdir $DOSSIER
fi

touch "$DOSSIERLOGS"$DATE"$LOG"

#liste des dossiers modifiés sur les dernières 24h
echo "Liste des dossiers modifiés sur les dernières 24h" | tee -a "$DOSSIERLOGS"$DATE"$LOG"
find "${COLLECTION}" -maxdepth 2 -type d -mtime -1 | tee -a "$DOSSIERLOGS"$DATE"$LOG" | tee -a /mnt/user/Documents/scripts/re3/achecker.txt

find "${COLLECTION}" -maxdepth 2 -type d > ${DOSSIER}liste2.txt

#dossiers ajoutés
echo "Artistes et albums créés ou modifiés" | tee -a "$DOSSIERLOGS"$DATE"$LOG"
diff -u ${DOSSIER}liste1.txt ${DOSSIER}liste2.txt | grep '^-' | sed 's/^-//' | tee -a "$DOSSIERLOGS"$DATE"$LOG"

#dossiers supprimés
echo "Artistes et albums supprimés ou modifiés" | tee -a "$DOSSIERLOGS"$DATE"$LOG"
diff -u ${DOSSIER}liste1.txt ${DOSSIER}liste2.txt | grep '^+' | sed 's/^+//' | tee -a "$DOSSIERLOGS"$DATE"$LOG"

rm ${DOSSIER}liste1.txt
mv ${DOSSIER}liste2.txt ${DOSSIER}liste1.txt