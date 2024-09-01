#!/bin/bash
############################################################################## 
#                                                                            #
#	SHELL: !/bin/bash       version 2                                        #
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
source .config.cfg

if [ ! -d $DOSSIERLOGS ];then
echo "Création du dossier Logs";
mkdir $DOSSIERLOGS
fi

touch "$DOSSIERLOGS"$DATE"$LOG"

#liste des fichiers modifiés sur les dernières 24h
echo "Liste des fichiers modifiés sur les dernières 24h (via find)" | tee -a "$DOSSIERLOGS"$DATE"$LOG"
find "${COLLECTION}" -maxdepth 3 -type f -mtime -1 \( -iname "*.flac" -o -iname "*.mp3" \) | cut -d'/' -f1-7 | uniq | tee -a "$LOG" | tee -a "$ACHECKER"

find "${COLLECTION}" -maxdepth 2 -type d > ${DOSSIER}liste2.txt

#dossiers ajoutés
echo "Artistes et albums créés ou modifiés (comparaison de listes)" | tee -a "$DOSSIERLOGS"$DATE"$LOG"
diff -u ${DOSSIER}liste1.txt ${DOSSIER}liste2.txt | grep '^-' | sed 's/^-//' | tee -a "$DOSSIERLOGS"$DATE"$LOG"

#dossiers supprimés
echo "Artistes et albums supprimés ou modifiés (comparaison de listes)" | tee -a "$DOSSIERLOGS"$DATE"$LOG"
diff -u ${DOSSIER}liste1.txt ${DOSSIER}liste2.txt | grep '^+' | sed 's/^+//' | tee -a "$DOSSIERLOGS"$DATE"$LOG"

rm ${DOSSIER}liste1.txt
mv ${DOSSIER}liste2.txt ${DOSSIER}liste1.txt