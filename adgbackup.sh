#!/bin/bash -e

dir=$(dirname "$(realpath "$0")")
cfg="$dir/adgbackup.cfg"

# Messages en couleur
error()    { echo -e "\033[0;31m====> $*\033[0m" ;}
message()  { echo -e "\033[0;32m====> $*\033[0m" ;}
warning()  { echo -e "\033[0;33m====> $*\033[0m" ;}

# Vérification du fichier de list
if [[ -f "$cfg" ]]; then
  . $cfg
else
  error "Fichier $cfg absent !"
  exit 1
fi

# Sauvegarde de l'application
if [[ -d $appdir ]]; then
  mkdir -p $destbackup
  warning "Sauvegarde..."
  bckfile="adguard.$(date '+%Y%m%d%H%M').tar.gz"
  sudo $appdir/AdGuardHome -s stop
  cd $appdir/.. && sudo tar cvf $bckfile $appdir
  sudo chown $user: $bckfile
  sudo mv $bckfile $destbackup
  sudo $appdir/AdGuardHome -s start
  find $destbackup -name adguard.*.gz -mtime +2 -exec rm {} \;
  message "Sauvegarde terminée"
fi
