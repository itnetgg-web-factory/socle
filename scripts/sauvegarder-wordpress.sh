#!/usr/bin/env bash
# Sauvegarde maison d'un site WordPress par SSH.
#
# Côté serveur, rien n'est écrit : la base est exportée par `wp db export -`
# et le dossier du site est archivé par `tar`, tous deux lus en flux.
#
# Usage :
#   sauvegarder-wordpress.sh sauvegarder <alias-ssh> <dossier-site-distant> <dossier-local> [options]
#   sauvegarder-wordpress.sh verifier <dossier-local> [heures-max]
#
# Options de « sauvegarder » :
#   --chiffrer-pour <identifiant-gpg>   chiffre les archives avec une clé publique GPG
#   --conserver <n>                     nombre de sauvegardes gardées (défaut : 14)
#
# « verifier » affiche l'âge de la dernière sauvegarde et échoue si elle date de
# plus de <heures-max> heures (défaut : 36).

set -euo pipefail
umask 077

erreur() { echo "Erreur : $*" >&2; exit 1; }

verifier() {
  local dossier="${1:-}" max="${2:-36}"
  [ -d "$dossier" ] || erreur "dossier introuvable : $dossier"
  local derniere
  derniere=$(find "$dossier" -mindepth 1 -maxdepth 1 -type d -name '20*' | sort | tail -1)
  [ -n "$derniere" ] || erreur "aucune sauvegarde dans $dossier"
  [ -f "$derniere/SHA256SUMS.txt" ] || erreur "sauvegarde incomplète : $derniere"
  local age
  age=$(( ( $(date +%s) - $(stat -f %m "$derniere/SHA256SUMS.txt" 2>/dev/null || stat -c %Y "$derniere/SHA256SUMS.txt") ) / 3600 ))
  echo "Dernière sauvegarde : $(basename "$derniere"), il y a ${age} h (maximum ${max} h)"
  [ "$age" -le "$max" ] || erreur "sauvegarde trop ancienne"
}

sauvegarder() {
  [ "$#" -ge 3 ] || erreur "arguments : <alias-ssh> <dossier-site-distant> <dossier-local>"
  local hote="$1" distant="$2" local_dir="$3"
  shift 3
  local gpg_dest="" conserver=14
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --chiffrer-pour) gpg_dest="${2:-}"; shift 2 ;;
      --conserver) conserver="${2:-}"; shift 2 ;;
      *) erreur "option inconnue : $1" ;;
    esac
  done
  [[ "$conserver" =~ ^[0-9]+$ ]] && [ "$conserver" -ge 1 ] || erreur "--conserver attend un entier positif"

  local horodatage cible
  horodatage=$(date +%Y-%m-%d-%H%M)
  cible="$local_dir/$horodatage"
  mkdir -p -m 700 "$local_dir"
  [ ! -e "$cible" ] || erreur "la sauvegarde $cible existe déjà"
  mkdir -m 700 "$cible"
  # En cas d'échec, ne laisser aucune sauvegarde partielle qui passerait pour complète.
  trap 'rm -rf "$cible"' ERR

  local q_distant parent site
  q_distant=$(printf '%q' "$distant")
  parent=$(printf '%q' "$(dirname "$distant")")
  site=$(printf '%q' "$(basename "$distant")")

  echo "1/4 Export de la base"
  ssh -o BatchMode=yes "$hote" "cd $q_distant && wp db export - --single-transaction" | gzip > "$cible/base.sql.gz"
  gzip -t "$cible/base.sql.gz" || erreur "export de la base illisible"
  gzip -dc "$cible/base.sql.gz" | tail -n 3 | grep -q 'Dump completed' || erreur "export de la base incomplet (« Dump completed » absent)"

  echo "2/4 Archive des fichiers"
  ssh -o BatchMode=yes "$hote" "tar -czf - -C $parent --exclude=error_log --exclude='*/wp-content/cache' $site" > "$cible/fichiers.tar.gz"
  tar -tzf "$cible/fichiers.tar.gz" > "$cible/.liste"
  grep -q '/wp-config\.php$' "$cible/.liste" || erreur "wp-config.php absent de l'archive"
  grep -q '/wp-content/' "$cible/.liste" || erreur "wp-content absent de l'archive"
  echo "    $(wc -l < "$cible/.liste" | tr -d ' ') entrées archivées"
  rm -f "$cible/.liste"

  if [ -n "$gpg_dest" ]; then
    echo "3/4 Chiffrement pour $gpg_dest"
    for f in base.sql.gz fichiers.tar.gz; do
      gpg --batch --yes --trust-model always --encrypt --recipient "$gpg_dest" --output "$cible/$f.gpg" "$cible/$f"
      rm -f "$cible/$f"
    done
  else
    echo "3/4 ATTENTION : archives non chiffrées (elles contiennent wp-config.php). Utiliser --chiffrer-pour ou un disque chiffré."
  fi

  echo "4/4 Empreintes et rotation"
  ( cd "$cible" && shasum -a 256 ./* | sed 's# \./# #' > SHA256SUMS.txt )
  trap - ERR
  local toutes total
  toutes=$(find "$local_dir" -mindepth 1 -maxdepth 1 -type d -name '20*' | sort)
  total=$(echo "$toutes" | wc -l | tr -d ' ')
  if [ "$total" -gt "$conserver" ]; then
    echo "$toutes" | head -n "$((total - conserver))" | while read -r d; do rm -rf "$d"; done
  fi
  echo "Sauvegarde terminée : $cible"
}

case "${1:-}" in
  sauvegarder) shift; sauvegarder "$@" ;;
  verifier) shift; verifier "$@" ;;
  *) sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
esac
