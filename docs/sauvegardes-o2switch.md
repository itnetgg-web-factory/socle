# Sauvegardes et restauration chez o2switch (JetBackup 5)

Procédure courte pour la filière WordPress hébergée chez o2switch. Elle complète le guide administrateur de `starter-wordpress` (section « Restaurer une version précédente »). Aucune information propre à un client ne figure ici.

Statut des étapes : **testé** (réalisé avec succès), **à tester** (libellés relevés mais non éprouvés, à confirmer à la première utilisation).

## Ce qu'il faut savoir

- Les sauvegardes sont automatiques et quotidiennes, conservées **30 jours** sur l'offre Grow (45 jours sur Cloud, 90 jours sur Pro).
- JetBackup 5 distingue les **sauvegardes de fichiers** (le dossier du compte, `/home/<compte>`) et les **sauvegardes de bases de données**. Un site WordPress en a besoin des deux.
- Les sauvegardes restent chez o2switch : **une copie hors de l'hébergeur** est nécessaire avant toute opération risquée (changement d'offre, migration, mise à jour majeure).
- L'outil « WP Tiger » sauvegarde **tout le site** : il convient pour une copie complète, pas pour récupérer un seul fichier.
- Une restauration est toujours **ciblée** : on coche ce qu'on veut restaurer. Restaurer le compte entier écrase tout ce qui a changé depuis la sauvegarde.

## Choisir la bonne méthode

| Besoin | Méthode |
|---|---|
| Page abîmée par le client | Révisions WordPress (voir le guide utilisateur), sans JetBackup |
| Code fautif | Pull request d'annulation (`git revert`), sans JetBackup |
| Un fichier supprimé ou modifié (image, thème) | **Restaurer un fichier** |
| Base de données endommagée | **Restaurer la base** |
| Site entier inutilisable | **Restaurer le site entier**, en dernier recours |
| Copie de précaution | **Télécharger une sauvegarde** |

## Restaurer un fichier *(testé)*

1. cPanel › **JetBackup 5** › **Sauvegardes de fichiers**.
2. Choisir la sauvegarde la plus récente d'avant l'incident.
3. Cliquer sur **Changer les fichiers**, puis naviguer jusqu'au dossier du fichier (par exemple `<site>/wp-content/uploads/2026/11/`).
4. Cocher **uniquement** le fichier voulu, puis **Restaurer**.
5. Suivre la tâche dans la **file d'attente** (*Queue*) jusqu'à son terme.
6. Vérifier : le fichier est revenu (même taille, même date) et la page qui l'utilise s'affiche.

Piège constaté lors du test : une restauration lancée sans passer par l'étape 3 a remis **tout le site** à l'état de la sauvegarde, pas seulement le fichier visé ; voir « Après une restauration ».

## Restaurer la base de données *(à tester)*

1. Avant : télécharger une sauvegarde de la base actuelle (voir plus bas), car la restauration écrase les contenus saisis depuis la sauvegarde.
2. cPanel › **JetBackup 5** › **Sauvegardes de bases de données**.
3. Choisir la sauvegarde, puis la base du site (celle indiquée dans `wp-config.php`, constante `DB_NAME`), puis **Restaurer**.
4. Suivre la file d'attente, puis vérifier le site.

## Restaurer le site entier *(à tester ; dernier recours)*

Restaurer d'abord les **fichiers** du dossier du site, puis la **base**, à partir de sauvegardes **de la même date**. Prévenir le client : ses modifications faites depuis cette date sont perdues.

## Télécharger une sauvegarde *(testé)*

1. cPanel › **JetBackup 5** › **Sauvegardes de fichiers** (ou **de bases de données**).
2. Sur la sauvegarde voulue, lancer le téléchargement. JetBackup prépare l'archive en arrière-plan : la tâche apparaît dans la **file d'attente** avec les colonnes *Type* (« Téléchargement »), *Informations* (compte, priorité), *Créée*, *Propriétaire*, *Délai d'exécution* (durée totale et temps réel) et *Statut*. Attendre le statut **Terminé**, puis récupérer l'archive.
   Ordre de grandeur mesuré : environ **17 minutes** pour un compte d'un peu moins de 1 Go. Ne pas fermer l'onglet inutilement : la tâche continue sans lui, mais le lien n'est proposé qu'à la fin.
3. Ranger l'archive hors de l'hébergeur, dans un emplacement chiffré. Les archives ne vont jamais dans Git.
4. Vérifier que l'archive s'ouvre et contient le dossier du site (fichiers) ou un fichier `.sql` (base).


## Après une restauration

Constaté lors du test : après une restauration du site entier, l'option « ne pas indexer » était revenue à son ancien état. Vérifier systématiquement :

1. Visibilité pour les moteurs de recherche (Réglages › Lecture) : activée en production, désactivée en préproduction.
2. Version de PHP et modules (OPcache) dans le sélecteur PHP de cPanel.
3. Extensions actives et version du thème.
4. Dernier commit déployé : fichier `wp-content/webfactory-deploiement.txt`. Si le code restauré est plus ancien, relancer le dernier déploiement de `main` (`gh run rerun`).
5. Comptes et mots de passe : une restauration de la base peut remettre d'anciens identifiants.
6. Formulaire de contact : un envoi de test.

## Rythme conseillé

| Quand | Quoi |
|---|---|
| Avant tout changement d'offre, migration ou mise à jour majeure | Télécharger fichiers et base, ranger hors hébergeur |
| Une fois par an | Restaurer un fichier de test, pour garder la procédure vivante |
| À chaque livraison client | Noter dans le dossier du projet la date de la dernière sauvegarde téléchargée |
