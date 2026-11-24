# Sauvegardes et restauration chez o2switch (JetBackup 5)

Procédure courte pour la filière WordPress hébergée chez o2switch. Elle complète le guide administrateur de `starter-wordpress` (section « Restaurer une version précédente »). Aucune information propre à un client ne figure ici.

Statut des étapes : **testé** (réalisé avec succès), **à tester** (libellés relevés mais non éprouvés, à confirmer à la première utilisation).

## Ce qu'il faut savoir

- Les sauvegardes sont automatiques et quotidiennes, conservées **30 jours** sur l'offre Grow (45 jours sur Cloud, 90 jours sur Pro).
- JetBackup 5 distingue les **sauvegardes de fichiers** (le dossier du compte, `/home/<compte>`) et les **sauvegardes de bases de données**. Un site WordPress en a besoin des deux.
- Les sauvegardes restent chez o2switch : **une copie hors de l'hébergeur** est nécessaire avant toute opération risquée (changement d'offre, migration, mise à jour majeure).
- L'outil « WP Tiger » sauvegarde **tout le site** : il convient pour une copie complète, pas pour récupérer un seul fichier.
- Une restauration est toujours **ciblée** : on coche ce qu'on veut restaurer. Restaurer le compte entier écrase tout ce qui a changé depuis la sauvegarde.

## Vérifier que les sauvegardes quotidiennes tournent

Ne pas supposer que la sauvegarde existe : lire la date de la dernière sauvegarde quotidienne dans JetBackup. Constaté lors d'un contrôle : les sauvegardes quotidiennes s'étaient arrêtées 41 jours plus tôt sans aucun signalement, et les anciennes restaient affichées.

| Quand | Quoi |
|---|---|
| Chaque semaine, et avant toute opération risquée | Date de la dernière sauvegarde quotidienne : elle doit dater de moins de 48 heures |
| Date trop ancienne | Ouvrir un ticket au support de l'hébergeur (compte, dates, demande d'une sauvegarde immédiate et de la cause) |
| En attendant | Faire une copie maison : export de la base (`wp db export`) et archive de `wp-content`, rangées hors de l'hébergeur |

## Copie maison automatisée *(testé)*

Les sauvegardes de l'hébergeur ne suffisent pas (voir ci-dessus). Le script [`scripts/sauvegarder-wordpress.sh`](../scripts/sauvegarder-wordpress.sh) fait une copie indépendante par SSH, en lecture seule côté serveur : rien n'est écrit sur l'hébergement.

```bash
# Sauvegarde : export de la base (wp db export), archive du dossier du site, empreintes SHA-256
scripts/sauvegarder-wordpress.sh sauvegarder <alias-ssh> <dossier-du-site-sur-le-serveur> <dossier-local> --chiffrer-pour <identifiant-gpg>

# Contrôle de fraîcheur : échoue si la dernière sauvegarde a plus de 36 heures
scripts/sauvegarder-wordpress.sh verifier <dossier-local>
```

Ce que le script contrôle avant de déclarer la sauvegarde terminée : export de la base lisible et terminé (« Dump completed »), archive lisible, `wp-config.php` et `wp-content` présents. En cas d'échec, la sauvegarde partielle est supprimée. Les anciennes sauvegardes sont supprimées au-delà de `--conserver` (14 par défaut).

Pièges et choix :

- **Les archives contiennent `wp-config.php`** (identifiants de la base, clés) : toujours les chiffrer (`--chiffrer-pour`, clé publique GPG dont la clé privée reste ailleurs) ou les ranger sur un disque chiffré. Sans l'une de ces protections, le script avertit.
- Le dossier local n'est jamais dans un dépôt Git, ni dans un dossier synchronisé non chiffré.
- La planification (launchd sur macOS, cron ailleurs) est à installer par la personne qui possède la machine : le Mac doit être allumé à l'heure choisie. Lancer `verifier` après, pour être alerté d'une sauvegarde manquée.
- Mesure : environ 10 secondes pour un site de 170 Mo (6 900 fichiers), archive de 56 Mo.

## Restaurer depuis la copie maison

### Essai de restauration en local *(testé avec Docker)*

À faire à blanc, pour prouver que la copie est utilisable sans toucher à l'hébergement. Durée mesurée : quelques minutes, images Docker déjà téléchargées.

1. Extraire l'archive des fichiers dans un dossier **neuf et vide** (elle contient des secrets : le supprimer après l'essai).
2. Lancer un conteneur `mariadb` (même version que l'hébergeur), créer la base du site et importer l'export (`gunzip -c base.sql.gz | docker exec -i <conteneur> mariadb …`).
3. Dans la **copie** de `wp-config.php` (jamais sur le serveur), remplacer `DB_HOST`, `DB_USER`, `DB_PASSWORD` par ceux du conteneur et ajouter `WP_HOME` et `WP_SITEURL` vers `http://localhost:<port>`.
4. Lancer le conteneur `wordpress:php8.4-apache` avec le dossier extrait monté sur `/var/www/html`.
5. Contrôler : la page d'accueil répond 200, le thème attendu est actif (version de `style.css`), les pages éditées se retrouvent à l'identique (même empreinte `md5` du contenu et même nombre de révisions qu'avant la sauvegarde), le bloc formulaire s'affiche.
6. Supprimer conteneurs, réseau et dossier extrait.

Résultat du premier essai : site complet restauré (19 tables, 25 enregistrements, thème 0.3.1, page éditée identique avec ses 11 révisions, carte ajoutée par le client présente).

### Restauration réelle sur l'hébergement *(testé)*

Durée mesurée : quelques minutes pour un site de 170 Mo. Le site est indisponible pendant l'échange des fichiers et l'import de la base (quelques secondes).

1. **Sauvegarder l'état actuel** avec le script (même cassé, il sert de point de retour), puis contrôler l'archive à restaurer.
2. Envoyer `base.sql.gz` et `fichiers.tar.gz` dans un dossier privé du compte, **hors du site** (`mkdir -m 700 ~/restauration`), et comparer les empreintes SHA-256 avec celles du Mac.
3. Extraire l'archive dans `~/restauration/extrait`, puis vérifier que `DB_NAME` du `wp-config.php` extrait est bien la base visée (`wp config get DB_NAME`). Sinon, s'arrêter.
4. Fichiers : **garder le dossier racine du site** et ne remplacer que son contenu, fichiers cachés compris (`shopt -s dotglob`) : déplacer le contenu actuel vers `~/restauration/avant`, puis le contenu extrait dans le dossier du site.
   Piège constaté : remplacer le dossier racine lui-même (`mv` du dossier extrait) rend le site inaccessible (**403** sur toutes les pages). Le dossier racine appartient au groupe `nobody`, qui permet au serveur web de le lire ; le compte ne peut pas redonner ce groupe. Remède : remettre le dossier d'origine et n'en échanger que le contenu.
5. Base : `gunzip -c ~/restauration/base.sql.gz | wp db import -` depuis le dossier du site.
6. Vérifier selon « Après une restauration », puis supprimer `~/restauration` (il contient `wp-config.php`) et les copies non chiffrées du Mac.

Le fichier `error_log` n'est pas dans la copie (exclu volontairement) : il manque après restauration, sans conséquence.

Résultat de l'essai : un brouillon et un fichier témoins posés après la sauvegarde ont disparu ; base, page éditée (même empreinte, 11 révisions), thème, extensions, 39 images, formulaire, visibilité pour les moteurs et témoin de déploiement identiques à l'état sauvegardé ; connexion Novamira intacte.

## Choisir la bonne méthode

| Besoin | Méthode |
|---|---|
| Page abîmée par le client | Révisions WordPress (voir le guide utilisateur), sans JetBackup |
| Code fautif | Pull request d'annulation (`git revert`), sans JetBackup |
| Un fichier supprimé ou modifié (image, thème) | **Restaurer un fichier** |
| Base de données endommagée | **Restaurer la base** |
| Site entier inutilisable | **Restaurer le site entier**, en dernier recours |
| Copie de précaution | **Télécharger une sauvegarde** |

## Restaurer un fichier *(à tester)*

1. cPanel › **JetBackup 5** › **Sauvegardes de fichiers**.
2. Choisir la sauvegarde la plus récente d'avant l'incident.
3. Cliquer sur **Changer les fichiers**, puis naviguer jusqu'au dossier du fichier (par exemple `<site>/wp-content/uploads/2026/11/`).
4. Cocher **uniquement** le fichier voulu, puis **Restaurer**.
5. Suivre la tâche dans la **file d'attente** (*Queue*) jusqu'à son terme.
6. Vérifier : le fichier est revenu (même taille, même date) et la page qui l'utilise s'affiche.

Piège constaté lors d'un premier essai : une restauration a remis **tout le site** à l'état d'une sauvegarde, pas seulement le fichier visé. L'outil utilisé (JetBackup ou WP Tiger, qui restaure un site entier) n'a pas pu être identifié : la restauration ciblée d'un seul fichier avec JetBackup reste à vérifier. Voir « Après une restauration ».

## Restaurer la base de données *(à tester)*

1. Avant : télécharger une sauvegarde de la base actuelle (voir plus bas), car la restauration écrase les contenus saisis depuis la sauvegarde.
2. cPanel › **JetBackup 5** › **Sauvegardes de bases de données**.
3. Choisir la sauvegarde, puis la base du site (celle indiquée dans `wp-config.php`, constante `DB_NAME`), puis **Restaurer**.
4. Suivre la file d'attente, puis vérifier le site.

## Restaurer le site entier *(à tester ; dernier recours)*

Restaurer d'abord les **fichiers** du dossier du site, puis la **base**, à partir de sauvegardes **de la même date**. Prévenir le client : ses modifications faites depuis cette date sont perdues.

## Télécharger une sauvegarde *(testé)*

Chaque type d'élément se télécharge **séparément** : dossier d'accueil, bases de données, e-mails, tâches cron, etc. L'archive du dossier d'accueil ne contient **pas** les bases : il faut aussi télécharger celles du site.

1. cPanel › **JetBackup 5** › **Sauvegardes de fichiers** (ou **de bases de données**). **Lire la date** de la ligne choisie et prendre la plus récente : une liste peut proposer des sauvegardes de plusieurs semaines, et un téléchargement lancé sur la mauvaise ligne donne une archive ancienne qui ne contient pas les derniers sites.
2. Sur la sauvegarde voulue, lancer le téléchargement. JetBackup prépare l'archive en arrière-plan : la tâche apparaît dans la **file d'attente** avec les colonnes *Type* (« Téléchargement »), *Informations* (compte, priorité), *Créée*, *Propriétaire*, *Délai d'exécution* (durée totale et temps réel) et *Statut*. Attendre le statut **Terminé**, puis récupérer l'archive.
    Ordre de grandeur mesuré : environ **17 minutes** pour un compte d'un peu moins de 1 Go. Ne pas fermer l'onglet inutilement : la tâche continue sans lui, mais le lien n'est proposé qu'à la fin.
3. Ranger l'archive hors de l'hébergeur, dans un emplacement chiffré. Les archives ne vont jamais dans Git.
4. **Contrôler l'archive avant de la ranger**, sans l'extraire : `tar -tzf <archive> | grep -m1 '<dossier-du-site>/'` doit afficher une ligne ; `tar -tzvf <archive> | tail -3` donne la date des fichiers les plus récents. Une archive qui ne contient pas le site attendu n'est pas une sauvegarde de ce site.
5. Une archive de compte contient des données sensibles (clés, certificats, `wp-config.php`, historique de commandes) : la ranger chiffrée, hors de tout dossier suivi par Git, et supprimer les copies intermédiaires.


## Copie complète d'un site WordPress avec WP Tiger *(testé)*

L'outil d'o2switch produit une archive unique du site : fichiers WordPress, `wp-config.php` et un export `.sql` de la base. Elle convient pour une copie de précaution d'un seul site. Elle ne remplace pas JetBackup, qui sauvegarde chaque jour et permet de restaurer un seul fichier.

## Après une restauration

Constaté lors du test : après une restauration du site entier, l'option « ne pas indexer » était revenue à son ancien état. Vérifier systématiquement :

1. Nom de la base : après la restauration du site entier, `DB_NAME` dans `wp-config.php` avait changé (`<compte>_wpNNN` devenue `<compte>_wpMMM`), signe d'une restauration dans une **nouvelle base** (outil vraisemblablement WP Tiger, non confirmé). Vérifier la base réellement utilisée ; l'ancienne reste sur le compte : ne la supprimer qu'après accord et sauvegarde.
2. Visibilité pour les moteurs de recherche (Réglages › Lecture) : activée en production, désactivée en préproduction.
3. Version de PHP et modules (OPcache) dans le sélecteur PHP de cPanel.
4. Extensions actives et version du thème.
5. Dernier commit déployé : fichier `wp-content/webfactory-deploiement.txt`. Si le code restauré est plus ancien, relancer le dernier déploiement de `main` (`gh run rerun`).
6. Comptes et mots de passe : une restauration de la base peut remettre d'anciens identifiants.
7. Formulaire de contact : un envoi de test.

## Rythme conseillé

| Quand | Quoi |
|---|---|
| Avant tout changement d'offre, migration ou mise à jour majeure | Télécharger fichiers et base, ranger hors hébergeur |
| Une fois par an | Restaurer un fichier de test, pour garder la procédure vivante |
| À chaque livraison client | Noter dans le dossier du projet la date de la dernière sauvegarde téléchargée |
