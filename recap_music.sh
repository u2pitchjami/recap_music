#!/bin/bash
############################################################################## 
#                                                                            #
#	SHELL: !/bin/bash       version 2.2                                      #
#									                                         #
#	NOM: u2pitchjami    					                                 #
#									                                         #
#	                    					                                 #
#									                                         #
#	DATE: 01/09/2024	           				                             #
#								                                    	     #
#	BUT: Récapitulation des changements dans ma base musicale                #
#									                                         #
############################################################################## 
#définition des variables
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ${SCRIPT_DIR}/.config.cfg

if [ ! -d $DOSSIERLOGS ];then
echo "Création du dossier Logs";
mkdir $DOSSIERLOGS
fi

touch "$LOG"
cat "$ACHECKER" > ${SCRIPT_DIR}/TEMP
#liste des fichiers modifiés sur les dernières 24h
echo "Liste des fichiers modifiés sur les dernières 24h (via find)" | tee -a "$LOG"
find ${COLLECTION} -maxdepth 2 -type f -mtime -1 \( -iname "*.flac" -o -iname "*.mp3" \) | cut -d'/' -f1-7 | uniq | tee -a "$LOG" | tee -a ${SCRIPT_DIR}/TEMP
#find ${COLLECTION} -maxdepth 3 -type f -mmin -60 \( -iname "*.flac" -o -iname "*.mp3" \) | cut -d'/' -f1-7 | uniq | tee -a "$LOG" | tee -a ${SCRIPT_DIR}/TEMP
find ${COLLECTION} -maxdepth 2 -mindepth 1 -type d > ${DOSSIER}liste2.txt

#dossiers ajoutés
echo "Artistes et albums créés ou modifiés (comparaison de listes)" | tee -a "$LOG"
diff -u ${DOSSIER}liste1.txt ${DOSSIER}liste2.txt | grep '^-' | sed 's/^-//' | tee -a "$LOG" | tee -a ${SCRIPT_DIR}/TEMP

#dossiers supprimés
echo "Artistes et albums supprimés ou modifiés (comparaison de listes)" | tee -a "$LOG"
diff -u ${DOSSIER}liste1.txt ${DOSSIER}liste2.txt | grep '^+' | sed 's/^+//' | tee -a "$LOG" | tee -a ${SCRIPT_DIR}/TEMP

sed -i "/liste1.txt/d" ${SCRIPT_DIR}/TEMP
sed -i "/liste2.txt/d" ${SCRIPT_DIR}/TEMP
sort ${SCRIPT_DIR}/TEMP | uniq > "$ACHECKER"

rm ${DOSSIER}liste1.txt
mv ${DOSSIER}liste2.txt ${DOSSIER}liste1.txt
rm ${SCRIPT_DIR}/TEMP